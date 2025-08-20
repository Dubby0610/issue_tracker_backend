const express = require('express');
const { body, validationResult } = require('express-validator');
const { Project, Issue, User } = require('../models');
const router = express.Router();

// Validation middleware
const validateProject = [
  body('name')
    .trim()
    .isLength({ min: 2, max: 200 })
    .withMessage('Project name must be between 2 and 200 characters'),
  body('description')
    .optional()
    .trim()
    .isLength({ max: 5000 })
    .withMessage('Description must not exceed 5000 characters'),
  body('status')
    .optional()
    .isIn(['active', 'on_hold', 'completed', 'archived'])
    .withMessage('Invalid status value')
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

// GET /projects - Get all projects
router.get('/', async (req, res) => {
  try {
    const projects = await Project.findAll({
      include: [
        {
          model: Issue,
          as: 'issues',
          attributes: ['id']
        }
      ],
      order: [['updated_at', 'DESC']]
    });

    // Add issues count to each project
    const projectsWithCount = projects.map(project => {
      const projectData = project.toJSON();
      projectData.issues_count = projectData.issues ? projectData.issues.length : 0;
      delete projectData.issues;
      return projectData;
    });

    res.json(projectsWithCount);
  } catch (error) {
    console.error('Error fetching projects:', error);
    res.status(500).json({ error: 'Failed to fetch projects' });
  }
});

// GET /projects/:id - Get project by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const project = await Project.findByPk(id, {
      include: [
        {
          model: Issue,
          as: 'issues',
          attributes: ['id']
        }
      ]
    });

    if (!project) {
      return res.status(404).json({ error: 'Project not found' });
    }

    const projectData = project.toJSON();
    projectData.issues_count = projectData.issues ? projectData.issues.length : 0;
    delete projectData.issues;

    res.json(projectData);
  } catch (error) {
    console.error('Error fetching project:', error);
    res.status(500).json({ error: 'Failed to fetch project' });
  }
});

// POST /projects - Create new project
router.post('/', validateProject, handleValidationErrors, async (req, res) => {
  try {
    const { name, description, status = 'active' } = req.body;
    
    const project = await Project.create({
      name,
      description,
      status
    });

    res.status(201).json(project);
  } catch (error) {
    console.error('Error creating project:', error);
    
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(400).json({ error: 'Project name already exists' });
    }
    
    res.status(500).json({ error: 'Failed to create project' });
  }
});

// PUT /projects/:id - Update project
router.put('/:id', validateProject, handleValidationErrors, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description, status } = req.body;
    
    const project = await Project.findByPk(id);
    
    if (!project) {
      return res.status(404).json({ error: 'Project not found' });
    }

    await project.update({
      name,
      description,
      status
    });

    res.json(project);
  } catch (error) {
    console.error('Error updating project:', error);
    
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(400).json({ error: 'Project name already exists' });
    }
    
    res.status(500).json({ error: 'Failed to update project' });
  }
});

// DELETE /projects/:id - Delete project
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const project = await Project.findByPk(id);
    
    if (!project) {
      return res.status(404).json({ error: 'Project not found' });
    }

    await project.destroy();
    
    res.status(204).send();
  } catch (error) {
    console.error('Error deleting project:', error);
    res.status(500).json({ error: 'Failed to delete project' });
  }
});

module.exports = router;
