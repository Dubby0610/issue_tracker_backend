# Issue Tracker Backend - Ruby on Rails API

A RESTful API built with Ruby on Rails for the Issue Tracker application. This backend provides endpoints for managing projects, issues, users, and comments.

## Features

- **Projects Management**: Create, read, update, and delete projects
- **Issues Tracking**: Full CRUD operations for issues with status and priority management
- **User Management**: User registration and profile management
- **Comments System**: Threaded comments on issues
- **Database**: PostgreSQL with ActiveRecord ORM
- **API**: RESTful JSON API with proper error handling
- **CORS**: Configured for frontend integration

## Technology Stack

- **Ruby on Rails 7.1+** - Web framework
- **PostgreSQL** - Database
- **Puma** - Web server
- **Rack-CORS** - Cross-origin resource sharing
- **BCrypt** - Password hashing (if authentication is added)

## Database Schema

### Users
- `id` (Primary Key)
- `name` (String, required, 2-100 chars)
- `email` (String, required, unique)
- `password` (String, optional for demo)
- `avatar_url` (String, optional)
- `is_active` (Boolean, default: true)
- `created_at`, `updated_at` (Timestamps)

### Projects
- `id` (Primary Key)
- `name` (String, required, 2-200 chars)
- `description` (Text, optional)
- `status` (Enum: active, on_hold, completed, archived)
- `start_date`, `end_date` (Dates, optional)
- `created_at`, `updated_at` (Timestamps)

### Issues
- `id` (Primary Key)
- `project_id` (Foreign Key to Projects)
- `title` (String, required, 3-500 chars)
- `description` (Text, optional)
- `status` (Enum: active, on_hold, resolved, closed)
- `priority` (Enum: low, medium, high, critical)
- `assigned_to_id` (Foreign Key to Users, optional)
- `reporter_id` (Foreign Key to Users, required)
- `due_date` (Date, optional)
- `created_at`, `updated_at` (Timestamps)

### Comments
- `id` (Primary Key)
- `issue_id` (Foreign Key to Issues)
- `user_id` (Foreign Key to Users)
- `content` (Text, required, 1-5000 chars)
- `is_internal` (Boolean, default: false)
- `created_at`, `updated_at` (Timestamps)

## Installation & Setup

### Prerequisites

1. **Ruby 3.2+** - Install from [RubyInstaller](https://rubyinstaller.org/) (Windows) or rbenv/rvm
2. **PostgreSQL** - Install and ensure it's running
3. **Bundler** - Install with `gem install bundler`

### Setup Steps

1. **Install dependencies:**
   ```bash
   bundle install
   ```

2. **Configure environment variables:**
   Copy `.env.example` to `.env` and update values:
   ```bash
   cp .env.example .env
   ```

3. **Setup database:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server:**
   ```bash
   rails server
   ```
   ```# Option 1: Use the batch file
   start_server.bat
   ```
   ```# Option 2: Direct Ruby command
   ruby bin/rails server -p 3001
   ```
   
   The API will be available at `http://localhost:3001`

## API Endpoints

### Health Check
- `GET /health` - Server health status

### Projects
- `GET /projects` - List all projects
- `GET /projects/:id` - Get project by ID
- `POST /projects` - Create new project
- `PUT /projects/:id` - Update project
- `DELETE /projects/:id` - Delete project

### Issues
- `GET /projects/:project_id/issues` - List issues for a project
- `GET /projects/:project_id/issues/:id` - Get issue by ID
- `POST /projects/:project_id/issues` - Create new issue
- `PUT /projects/:project_id/issues/:id` - Update issue
- `DELETE /projects/:project_id/issues/:id` - Delete issue

### Users
- `GET /users` - List all active users
- `GET /users/:id` - Get user by ID
- `POST /users` - Create new user
- `PUT /users/:id` - Update user
- `DELETE /users/:id` - Deactivate user (soft delete)

### Comments
- `GET /projects/:project_id/issues/:issue_id/comments` - List comments for an issue
- `POST /projects/:project_id/issues/:issue_id/comments` - Create new comment
- `PUT /comments/:id` - Update comment
- `DELETE /comments/:id` - Delete comment

## Sample API Requests

### Create a Project
```bash
curl -X POST http://localhost:3001/projects \
  -H "Content-Type: application/json" \
  -d '{
    "project": {
      "name": "New Project",
      "description": "Project description",
      "status": "active"
    }
  }'
```

### Create an Issue
```bash
curl -X POST http://localhost:3001/projects/1/issues \
  -H "Content-Type: application/json" \
  -d '{
    "issue": {
      "title": "Bug fix needed",
      "description": "Fix the login issue",
      "status": "active",
      "priority": "high",
      "reporter_id": 1,
      "assigned_to_id": 2
    }
  }'
```

## Error Handling

The API returns appropriate HTTP status codes and JSON error messages:

- `200` - Success
- `201` - Created
- `204` - No Content (for deletions)
- `400` - Bad Request (validation errors)
- `404` - Not Found
- `422` - Unprocessable Entity (model validation errors)
- `500` - Internal Server Error

Error response format:
```json
{
  "error": "Error description",
  "details": ["Validation error 1", "Validation error 2"],
  "timestamp": "2024-01-01T12:00:00Z"
}
```

## Development

### Running Tests
```bash
bundle exec rspec
```

### Database Operations
```bash
rails db:reset          # Drop, create, migrate, and seed
rails db:migrate         # Run pending migrations
rails db:rollback        # Rollback last migration
rails db:seed            # Load seed data
```

### Console
```bash
rails console            # Interactive Ruby console with models loaded
```

## Sample Data

The seed file creates:
- 6 sample users (Charlie Davis, Bob Wilson, Alice Johnson, Person 1-3)
- 4 projects (1111, Website Redesign, Mobile App, API Migration)
- 6 issues with various statuses and assignments
- 5 comments on different issues

## CORS Configuration

The API is configured to accept requests from `http://localhost:3000` by default (React frontend). Update the `FRONTEND_URL` environment variable to change this.

## Deployment

For production deployment:

1. Set environment variables in your hosting platform
2. Update database configuration for production
3. Set `RAILS_ENV=production`
4. Run `rails assets:precompile` if using any assets
5. Run `rails db:migrate` on production database

## Migration from Node.js

This Rails backend is a complete replacement for the previous Node.js/Express backend, providing:

- Same API endpoints and request/response formats
- Same database schema and relationships
- Same validation rules and business logic
- Improved error handling and logging
- Better code organization using Rails conventions

The frontend application should work without any changes after switching to this Rails backend.