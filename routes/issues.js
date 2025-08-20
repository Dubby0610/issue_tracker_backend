const express = require('express');
const { body, validationResult } = require('express-validator');
const { Issue, Project, User, Comment } = require('../models');
const router = express.Router();

// Validation middleware
const validateIssue = [
  body('title')
    .trim()
    .isLength({ min: 3, max: 500 })
    .withMessage('Issue title must be between 3 and 500 characters'),
  body('description')
    .optional()
    .trim()
    .isLength({ max: 5000 })
    .withMessage('Description must not exceed 5000 characters'),
  body('status')
    .optional()
    .isIn(['active', 'on_hold', 'resolved', 'closed'])
    .withMessage('Invalid status value'),
  body('priority')
    .optional()
    .isIn(['low', 'medium', 'high', 'critical'])
    .withMessage('Invalid priority value'),
  body('assigned_to_id')
    .optional()
    .isInt({ min: 1 })
    .withMessage('Assigned to ID must be a positive integer'),
  body('reporter_id')
    .isInt({ min: 1 })
    .withMessage('Reporter ID must be a positive integer')
];

// Error handling middleware
const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      error: 'Validation failed',
      details: errors.array()
    });
  }
  next();
};

// GET /projects/:projectId/issues - Get all issues for a project
router.get('/:projectId/issues', async (req, res) => {
  try {
    const { projectId } = req.params;
    
    // Verify project exists
    const project = await Project.findByPk(projectId);
    if (!project) {
      return res.status(404).json({ error: 'Project not found' });
    }

    const issues = await Issue.findAll({
      where: { project_id: projectId },
      include: [
        {
          model: User,
          as: 'assigned_to',
          attributes: ['id', 'name', 'email']
        },
        {
          model: User,
          as: 'reporter',
          attributes: ['id', 'name', 'email']
        },
        {
          model: Project,
          as: 'project',
          attributes: ['id', 'name']
        }
      ],
      order: [['created_at', 'DESC']]
    });

    res.json(issues);
  } catch (error) {
    console.error('Error fetching issues:', error);
    res.status(500).json({ error: 'Failed to fetch issues' });
  }
});

// GET /projects/:projectId/issues/:id - Get issue by ID
router.get('/:projectId/issues/:id', async (req, res) => {
  try {
    const { projectId, id } = req.params;
    
    const issue = await Issue.findOne({
      where: { 
        id,
        project_id: projectId 
      },
      include: [
        {
          model: User,
          as: 'assigned_to',
          attributes: ['id', 'name', 'email']
        },
        {
          model: User,
          as: 'reporter',
          attributes: ['id', 'name', 'email']
        },
        {
          model: Project,
          as: 'project',
          attributes: ['id', 'name']
        },
        {
          model: Comment,
          as: 'comments',
          include: [
            {
              model: User,
              as: 'user',
              attributes: ['id', 'name', 'email']
            }
          ],
          order: [['created_at', 'ASC']]
        }
      ]
    });

    if (!issue) {
      return res.status(404).json({ error: 'Issue not found' });
    }

    res.json(issue);
  } catch (error) {
    console.error('Error fetching issue:', error);
    res.status(500).json({ error: 'Failed to fetch issue' });
  }
});

// POST /projects/:projectId/issues - Create new issue
router.post('/:projectId/issues', validateIssue, handleValidationErrors, async (req, res) => {
  try {
    const { projectId } = req.params;
    const { title, description, status = 'active', priority = 'medium', assigned_to_id, reporter_id } = req.body;
    
    // Verify project exists
    const project = await Project.findByPk(projectId);
    if (!project) {
      return res.status(404).json({ error: 'Project not found' });
    }

    // Verify reporter exists
    const reporter = await User.findByPk(reporter_id);
    if (!reporter) {
      return res.status(400).json({ error: 'Reporter not found' });
    }

    // Verify assigned user exists if provided
    if (assigned_to_id) {
      const assignedUser = await User.findByPk(assigned_to_id);
      if (!assignedUser) {
        return res.status(400).json({ error: 'Assigned user not found' });
      }
    }

    const issue = await Issue.create({
      project_id: projectId,
      title,
      description,
      status,
      priority,
      assigned_to_id: assigned_to_id || null,
      reporter_id
    });

    // Fetch the created issue with associations
    const createdIssue = await Issue.findByPk(issue.id, {
      include: [
        {
          model: User,
          as: 'assigned_to',
          attributes: ['id', 'name', 'email']
        },
        {
          model: User,
          as: 'reporter',
          attributes: ['id', 'name', 'email']
        },
        {
          model: Project,
          as: 'project',
          attributes: ['id', 'name']
        }
      ]
    });

    res.status(201).json(createdIssue);
  } catch (error) {
    console.error('Error creating issue:', error);
    res.status(500).json({ error: 'Failed to create issue' });
  }
});

// PUT /projects/:projectId/issues/:id - Update issue
router.put('/:projectId/issues/:id', validateIssue, handleValidationErrors, async (req, res) => {
  try {
    const { projectId, id } = req.params;
    const { title, description, status, priority, assigned_to_id, reporter_id } = req.body;
    
    const issue = await Issue.findOne({
      where: { 
        id,
        project_id: projectId 
      }
    });
    
    if (!issue) {
      return res.status(404).json({ error: 'Issue not found' });
    }

    // Verify reporter exists
    if (reporter_id) {
      const reporter = await User.findByPk(reporter_id);
      if (!reporter) {
        return res.status(400).json({ error: 'Reporter not found' });
      }
    }

    // Verify assigned user exists if provided
    if (assigned_to_id) {
      const assignedUser = await User.findByPk(assigned_to_id);
      if (!assignedUser) {
        return res.status(400).json({ error: 'Assigned user not found' });
      }
    }

    await issue.update({
      title,
      description,
      status,
      priority,
      assigned_to_id: assigned_to_id || null,
      reporter_id
    });

    // Fetch the updated issue with associations
    const updatedIssue = await Issue.findByPk(issue.id, {
      include: [
        {
          model: User,
          as: 'assigned_to',
          attributes: ['id', 'name', 'email']
        },
        {
          model: User,
          as: 'reporter',
          attributes: ['id', 'name', 'email']
        },
        {
          model: Project,
          as: 'project',
          attributes: ['id', 'name']
        }
      ]
    });

    res.json(updatedIssue);
  } catch (error) {
    console.error('Error updating issue:', error);
    res.status(500).json({ error: 'Failed to update issue' });
  }
});

// DELETE /projects/:projectId/issues/:id - Delete issue
router.delete('/:projectId/issues/:id', async (req, res) => {
  try {
    const { projectId, id } = req.params;
    
    const issue = await Issue.findOne({
      where: { 
        id,
        project_id: projectId 
      }
    });
    
    if (!issue) {
      return res.status(404).json({ error: 'Issue not found' });
    }

    await issue.destroy();
    
    res.status(204).send();
  } catch (error) {
    console.error('Error deleting issue:', error);
    res.status(500).json({ error: 'Failed to delete issue' });
  }
});

module.exports = router;
