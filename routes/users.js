const express = require('express');
const { body, validationResult } = require('express-validator');
const { User, Issue, Comment } = require('../models');
const router = express.Router();

// Validation middleware
const validateUser = [
  body('name')
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage('User name must be between 2 and 100 characters'),
  body('email')
    .isEmail()
    .normalizeEmail()
    .withMessage('Please provide a valid email address')
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

// GET /users - Get all users
router.get('/', async (req, res) => {
  try {
    const users = await User.findAll({
      where: { is_active: true },
      attributes: ['id', 'name', 'email', 'avatar_url', 'created_at'],
      order: [['name', 'ASC']]
    });

    res.json(users);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Failed to fetch users' });
  }
});

// GET /users/:id - Get user by ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const user = await User.findByPk(id, {
      attributes: ['id', 'name', 'email', 'avatar_url', 'created_at'],
      include: [
        {
          model: Issue,
          as: 'assigned_issues',
          attributes: ['id', 'title', 'status']
        },
        {
          model: Issue,
          as: 'reported_issues',
          attributes: ['id', 'title', 'status']
        }
      ]
    });

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(user);
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ error: 'Failed to fetch user' });
  }
});

// POST /users - Create new user
router.post('/', validateUser, handleValidationErrors, async (req, res) => {
  try {
    const { name, email, avatar_url } = req.body;
    
    const user = await User.create({
      name,
      email,
      avatar_url
    });

    res.status(201).json({
      id: user.id,
      name: user.name,
      email: user.email,
      avatar_url: user.avatar_url,
      created_at: user.created_at
    });
  } catch (error) {
    console.error('Error creating user:', error);
    
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(400).json({ error: 'Email already exists' });
    }
    
    res.status(500).json({ error: 'Failed to create user' });
  }
});

// PUT /users/:id - Update user
router.put('/:id', validateUser, handleValidationErrors, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, email, avatar_url } = req.body;
    
    const user = await User.findByPk(id);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    await user.update({
      name,
      email,
      avatar_url
    });

    res.json({
      id: user.id,
      name: user.name,
      email: user.email,
      avatar_url: user.avatar_url,
      created_at: user.created_at
    });
  } catch (error) {
    console.error('Error updating user:', error);
    
    if (error.name === 'SequelizeUniqueConstraintError') {
      return res.status(400).json({ error: 'Email already exists' });
    }
    
    res.status(500).json({ error: 'Failed to update user' });
  }
});

// DELETE /users/:id - Deactivate user (soft delete)
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const user = await User.findByPk(id);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    await user.update({ is_active: false });
    
    res.status(204).send();
  } catch (error) {
    console.error('Error deactivating user:', error);
    res.status(500).json({ error: 'Failed to deactivate user' });
  }
});

module.exports = router;
