# Ruby on Rails Backend Setup Guide

## Quick Start (After Ruby and Rails Installation)

### 1. Install Ruby and Rails (One-time setup)

**For Windows:**
1. Download Ruby+Devkit from [RubyInstaller.org](https://rubyinstaller.org/downloads/)
2. Install Ruby (latest stable version, e.g., Ruby 3.2.x)
3. During installation, check "Add Ruby executables to your PATH"
4. Open a new Command Prompt or PowerShell and run:
   ```bash
   gem install rails bundler
   ruby --version
   rails --version
   ```

### 2. Setup the Project

1. **Navigate to the backend directory:**
   ```bash
   cd issue_tracker_backend
   ```

2. **Install dependencies:**
   ```bash
   bundle install
   ```

3. **Create environment file:**
   Create a `.env` file in the backend directory with:
   ```
   DB_USER=postgres
   DB_PASSWORD=password
   DB_NAME=issue_tracker_development
   DB_HOST=localhost
   DB_PORT=5432
   FRONTEND_URL=http://localhost:3000
   RAILS_ENV=development
   PORT=3001
   ```

4. **Setup PostgreSQL database:**
   - Make sure PostgreSQL is installed and running
   - Update database credentials in `.env` file if needed

5. **Create and setup database:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

6. **Start the server:**
   ```bash
   rails server
   ```

The API will be available at `http://localhost:3001`

## Testing the API

### Health Check
```bash
curl http://localhost:3001/health
```

### Get Projects
```bash
curl http://localhost:3001/projects
```

### Get Users
```bash
curl http://localhost:3001/users
```

## Common Issues & Solutions

### Issue: "rails: command not found"
**Solution:** Ensure Ruby and Rails are properly installed and in your PATH.

### Issue: Database connection errors
**Solution:** 
1. Verify PostgreSQL is running
2. Check database credentials in `.env` file
3. Ensure database user has proper permissions

### Issue: "Could not find gem" errors
**Solution:** Run `bundle install` to install missing gems

### Issue: Migration errors
**Solution:** 
1. Drop and recreate database: `rails db:drop db:create db:migrate db:seed`
2. Check for any custom database configurations

## Development Commands

```bash
# Start development server
rails server

# Open Rails console
rails console

# Run database migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Reset database (drop, create, migrate, seed)
rails db:reset

# Load seed data
rails db:seed

# Run tests (when test suite is added)
bundle exec rspec
```

## API Documentation

The API provides the following endpoints:

### Projects
- `GET /projects` - List all projects
- `GET /projects/:id` - Get project details
- `POST /projects` - Create project
- `PUT /projects/:id` - Update project
- `DELETE /projects/:id` - Delete project

### Issues
- `GET /projects/:project_id/issues` - List project issues
- `GET /projects/:project_id/issues/:id` - Get issue details
- `POST /projects/:project_id/issues` - Create issue
- `PUT /projects/:project_id/issues/:id` - Update issue
- `DELETE /projects/:project_id/issues/:id` - Delete issue

### Users
- `GET /users` - List all users
- `GET /users/:id` - Get user details
- `POST /users` - Create user
- `PUT /users/:id` - Update user
- `DELETE /users/:id` - Deactivate user

### Comments
- `GET /projects/:project_id/issues/:issue_id/comments` - List issue comments
- `POST /projects/:project_id/issues/:issue_id/comments` - Create comment
- `PUT /comments/:id` - Update comment
- `DELETE /comments/:id` - Delete comment

## Frontend Integration

The Rails backend is configured to work with the existing React frontend at `http://localhost:3000`. The CORS settings are already configured to allow requests from the frontend.

**No changes should be needed in the frontend application** - it will work with the same API endpoints and response formats as the previous Node.js backend.

## Next Steps

1. Start the Rails server with `rails server`
2. Verify the API endpoints work with curl or Postman
3. Test the frontend application to ensure it connects properly
4. Optionally add authentication, authorization, or additional features as needed

The Rails backend is now ready and provides the exact same functionality as the previous Node.js/Express backend!
