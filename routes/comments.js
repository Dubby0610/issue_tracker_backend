const express = require('express');
const { body, validationResult } = require('express-validator');
const { Comment, Issue, User } = require('../models');
const router = express.Router();

// Validation middleware
const validateComment = [
  body('content')
    .trim()
    .isLength({ min: 1, max: 5000 })
    .withMessage('Comment content must be between 1 and 5000 characters'),
  body('user_id')
    .isInt({ min: 1 })
    .withMessage('User ID must be a positive integer')
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

// GET /issues/:issueId/comments - Get all comments for an issue
router.get('/:issueId/comments', async (req, res) => {
  try {
    const { issueId } = req.params;
    
    // Verify issue exists
    const issue = await Issue.findByPk(issueId);
    if (!issue) {
      return res.status(404).json({ error: 'Issue not found' });
    }

    const comments = await Comment.findAll({
      where: { issue_id: issueId },
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'name', 'email']
        }
      ],
      order: [['created_at', 'ASC']]
    });

    res.json(comments);
  } catch (error) {
    console.error('Error fetching comments:', error);
    res.status(500).json({ error: 'Failed to fetch comments' });
  }
});

// POST /issues/:issueId/comments - Create new comment
router.post('/:issueId/comments', validateComment, handleValidationErrors, async (req, res) => {
  try {
    const { issueId } = req.params;
    const { content, user_id, is_internal = false } = req.body;
    
    // Verify issue exists
    const issue = await Issue.findByPk(issueId);
    if (!issue) {
      return res.status(404).json({ error: 'Issue not found' });
    }

    // Verify user exists
    const user = await User.findByPk(user_id);
    if (!user) {
      return res.status(400).json({ error: 'User not found' });
    }

    const comment = await Comment.create({
      issue_id: issueId,
      user_id,
      content,
      is_internal
    });

    // Fetch the created comment with user information
    const createdComment = await Comment.findByPk(comment.id, {
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'name', 'email']
        }
      ]
    });

    res.status(201).json(createdComment);
  } catch (error) {
    console.error('Error creating comment:', error);
    res.status(500).json({ error: 'Failed to create comment' });
  }
});

// PUT /comments/:id - Update comment
router.put('/comments/:id', validateComment, handleValidationErrors, async (req, res) => {
  try {
    const { id } = req.params;
    const { content, is_internal } = req.body;
    
    const comment = await Comment.findByPk(id);
    
    if (!comment) {
      return res.status(404).json({ error: 'Comment not found' });
    }

    await comment.update({
      content,
      is_internal: is_internal !== undefined ? is_internal : comment.is_internal
    });

    // Fetch the updated comment with user information
    const updatedComment = await Comment.findByPk(comment.id, {
      include: [
        {
          model: User,
          as: 'user',
          attributes: ['id', 'name', 'email']
        }
      ]
    });

    res.json(updatedComment);
  } catch (error) {
    console.error('Error updating comment:', error);
    res.status(500).json({ error: 'Failed to update comment' });
  }
});

// DELETE /comments/:id - Delete comment
router.delete('/comments/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const comment = await Comment.findByPk(id);
    
    if (!comment) {
      return res.status(404).json({ error: 'Comment not found' });
    }

    await comment.destroy();
    
    res.status(204).send();
  } catch (error) {
    console.error('Error deleting comment:', error);
    res.status(500).json({ error: 'Failed to delete comment' });
  }
});

module.exports = router;
