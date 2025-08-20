# Issue Tracker Backend

A Node.js/Express REST API backend for the Issue Tracker application, providing complete CRUD operations for projects, issues, comments, and users.

## Features

- **RESTful API** with full CRUD operations
- **PostgreSQL** database with Sequelize ORM
- **Comprehensive validation** using express-validator
- **CORS support** for cross-origin requests
- **Error handling** with detailed error messages
- **Database seeding** with sample data
- **Production-ready** deployment configuration

## API Endpoints

### Projects
- `GET /projects` - Get all projects
- `GET /projects/:id` - Get project by ID
- `POST /projects` - Create new project
- `PUT /projects/:id` - Update project
- `DELETE /projects/:id` - Delete project

### Issues
- `GET /projects/:projectId/issues` - Get all issues for a project
- `GET /projects/:projectId/issues/:id` - Get issue by ID
- `POST /projects/:projectId/issues` - Create new issue
- `PUT /projects/:projectId/issues/:id` - Update issue
- `DELETE /projects/:projectId/issues/:id` - Delete issue

### Comments
- `GET /issues/:issueId/comments` - Get all comments for an issue
- `POST /issues/:issueId/comments` - Create new comment
- `PUT /comments/:id` - Update comment
- `DELETE /comments/:id` - Delete comment

### Users
- `GET /users` - Get all users
- `GET /users/:id` - Get user by ID
- `POST /users` - Create new user
- `PUT /users/:id` - Update user
- `DELETE /users/:id` - Deactivate user

## Local Development

### Prerequisites
- Node.js (v14 or higher)
- PostgreSQL database

### Setup
1. Install dependencies:
   ```bash
   npm install
   ```

2. Set up environment variables (create `.env` file):
   ```
   DB_HOST=localhost
   DB_PORT=5432
   DB_NAME=issue_tracker_development
   DB_USER=postgres
   DB_PASSWORD=your_password
   PORT=3001
   NODE_ENV=development
   JWT_SECRET=your-super-secret-jwt-key
   FRONTEND_URL=http://localhost:3000
   ```

3. Create PostgreSQL database:
   ```sql
   CREATE DATABASE issue_tracker_development;
   ```

4. Seed the database with sample data:
   ```bash
   npm run seed
   ```

5. Start the development server:
   ```bash
   npm run dev
   ```

The API will be available at `http://localhost:3001`

## Production Deployment (Render.com)

1. **Fork/Clone** this repository to your GitHub account

2. **Create a new Web Service** on Render.com:
   - Connect your GitHub repository
   - Set the build command: `npm install`
   - Set the start command: `npm start`
   - Set the environment to `Node`

3. **Create a PostgreSQL database** on Render.com:
   - Add a new PostgreSQL database
   - Note the connection details

4. **Configure environment variables** in Render dashboard:
   - `NODE_ENV`: `production`
   - `PORT`: `3001`
   - `DB_HOST`: (from PostgreSQL database)
   - `DB_PORT`: (from PostgreSQL database)
   - `DB_NAME`: (from PostgreSQL database)
   - `DB_USER`: (from PostgreSQL database)
   - `DB_PASSWORD`: (from PostgreSQL database)
   - `JWT_SECRET`: (generate a secure random string)
   - `FRONTEND_URL`: (your frontend Vercel URL)

5. **Deploy** and the database will automatically sync on first run

6. **Seed the production database** (optional):
   - Connect to your deployed service
   - Run the seed script via Render shell or deploy endpoint

## Database Schema

### Users
- `id` (Primary Key)
- `name` (String, required)
- `email` (String, unique, required)
- `password` (String, optional)
- `avatar_url` (String, optional)
- `is_active` (Boolean, default: true)

### Projects
- `id` (Primary Key)
- `name` (String, required)
- `description` (Text, optional)
- `status` (Enum: active, on_hold, completed, archived)
- `start_date` (Date, optional)
- `end_date` (Date, optional)

### Issues
- `id` (Primary Key)
- `project_id` (Foreign Key to Projects)
- `title` (String, required)
- `description` (Text, optional)
- `status` (Enum: active, on_hold, resolved, closed)
- `priority` (Enum: low, medium, high, critical)
- `assigned_to_id` (Foreign Key to Users, optional)
- `reporter_id` (Foreign Key to Users, required)
- `due_date` (Date, optional)

### Comments
- `id` (Primary Key)
- `issue_id` (Foreign Key to Issues)
- `user_id` (Foreign Key to Users)
- `content` (Text, required)
- `is_internal` (Boolean, default: false)

## Technologies Used

- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **Sequelize** - ORM for PostgreSQL
- **PostgreSQL** - Database
- **express-validator** - Input validation
- **CORS** - Cross-origin resource sharing
- **Helmet** - Security middleware
- **Morgan** - HTTP request logger

## Scripts

- `npm start` - Start production server
- `npm run dev` - Start development server with nodemon
- `npm run seed` - Seed database with sample data
