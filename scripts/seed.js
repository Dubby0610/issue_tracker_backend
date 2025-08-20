const { sequelize, User, Project, Issue, Comment } = require('../models');

async function seedDatabase() {
  try {
    console.log('Connecting to database...');
    await sequelize.authenticate();
    
    console.log('Syncing database models...');
    await sequelize.sync({ force: true }); // This will drop and recreate tables
    
    console.log('Creating users...');
    const users = await User.bulkCreate([
      {
        name: 'Charlie Davis',
        email: 'charlie.davis@example.com'
      },
      {
        name: 'Bob Wilson',
        email: 'bob.wilson@example.com'
      },
      {
        name: 'Alice Johnson',
        email: 'alice.johnson@example.com'
      },
      {
        name: 'Person 1',
        email: 'person1@example.com'
      },
      {
        name: 'Person 2',
        email: 'person2@example.com'
      },
      {
        name: 'Person 3',
        email: 'person3@example.com'
      }
    ]);

    console.log('Creating projects...');
    const projects = await Project.bulkCreate([
      {
        name: '1111',
        description: 'Test project for development',
        status: 'active'
      },
      {
        name: 'Website Redesign',
        description: 'Complete redesign of the company website',
        status: 'active'
      },
      {
        name: 'Mobile App',
        description: 'Development of mobile application',
        status: 'on_hold'
      },
      {
        name: 'API Migration',
        description: 'Migrate legacy API to new architecture',
        status: 'completed'
      }
    ]);

    console.log('Creating issues...');
    const issues = await Issue.bulkCreate([
      {
        project_id: projects[0].id,
        title: 'qweqweqw',
        description: 'qweqweqwewe',
        status: 'resolved',
        priority: 'medium',
        assigned_to_id: users[1].id, // Bob Wilson
        reporter_id: users[0].id // Charlie Davis
      },
      {
        project_id: projects[0].id,
        title: 'Fix a thing',
        description: 'This is a text explaining the issue in details\nIt\'s just plain text\nAnd it can be several line or a lot of text',
        status: 'active',
        priority: 'high',
        assigned_to_id: users[3].id, // Person 1
        reporter_id: users[0].id // Charlie Davis
      },
      {
        project_id: projects[0].id,
        title: 'Create this thing',
        description: 'Need to implement new feature',
        status: 'active',
        priority: 'medium',
        assigned_to_id: users[3].id, // Person 1
        reporter_id: users[1].id // Bob Wilson
      },
      {
        project_id: projects[0].id,
        title: 'Do this',
        description: 'Important task that needs attention',
        status: 'on_hold',
        priority: 'low',
        assigned_to_id: users[4].id, // Person 2
        reporter_id: users[2].id // Alice Johnson
      },
      {
        project_id: projects[1].id,
        title: 'Update homepage design',
        description: 'The homepage needs a complete visual overhaul',
        status: 'active',
        priority: 'high',
        assigned_to_id: users[2].id, // Alice Johnson
        reporter_id: users[0].id // Charlie Davis
      },
      {
        project_id: projects[2].id,
        title: 'Implement user authentication',
        description: 'Add login and registration functionality',
        status: 'on_hold',
        priority: 'critical',
        assigned_to_id: users[1].id, // Bob Wilson
        reporter_id: users[2].id // Alice Johnson
      }
    ]);

    console.log('Creating comments...');
    await Comment.bulkCreate([
      {
        issue_id: issues[1].id, // Fix a thing
        user_id: users[1].id, // Bob Wilson
        content: 'Ok, I have seen this issue, and will try to fix it'
      },
      {
        issue_id: issues[1].id, // Fix a thing
        user_id: users[3].id, // Person 1
        content: 'I need your feedback on some things go fix this'
      },
      {
        issue_id: issues[0].id, // qweqweqw
        user_id: users[0].id, // Charlie Davis
        content: 'This issue has been resolved successfully'
      },
      {
        issue_id: issues[4].id, // Update homepage design
        user_id: users[2].id, // Alice Johnson
        content: 'I\'ve started working on the mockups for the new design'
      },
      {
        issue_id: issues[4].id, // Update homepage design
        user_id: users[0].id, // Charlie Davis
        content: 'Great! Please make sure to follow the brand guidelines'
      }
    ]);

    console.log('Database seeded successfully!');
    console.log(`Created ${users.length} users`);
    console.log(`Created ${projects.length} projects`);
    console.log(`Created ${issues.length} issues`);
    console.log('Seed data includes:');
    console.log('- Users: Charlie Davis, Bob Wilson, Alice Johnson, Person 1, Person 2, Person 3');
    console.log('- Projects: 1111, Website Redesign, Mobile App, API Migration');
    console.log('- Issues with various statuses and assignments');
    console.log('- Comments on several issues');

  } catch (error) {
    console.error('Error seeding database:', error);
  } finally {
    await sequelize.close();
  }
}

// Run the seed function
seedDatabase();
