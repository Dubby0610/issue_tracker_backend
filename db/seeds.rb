# Clear existing data
puts "Clearing existing data..."
Comment.destroy_all
Issue.destroy_all
Project.destroy_all
User.destroy_all

puts "Creating users..."
users = User.create!([
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
])

puts "Creating projects..."
projects = Project.create!([
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
])

puts "Creating issues..."
issues = Issue.create!([
  {
    project: projects[0],
    title: 'qweqweqw',
    description: 'qweqweqwewe',
    status: 'resolved',
    priority: 'medium',
    assigned_to: users[1], # Bob Wilson
    reporter: users[0] # Charlie Davis
  },
  {
    project: projects[0],
    title: 'Fix a thing',
    description: "This is a text explaining the issue in details\nIt's just plain text\nAnd it can be several line or a lot of text",
    status: 'active',
    priority: 'high',
    assigned_to: users[3], # Person 1
    reporter: users[0] # Charlie Davis
  },
  {
    project: projects[0],
    title: 'Create this thing',
    description: 'Need to implement new feature',
    status: 'active',
    priority: 'medium',
    assigned_to: users[3], # Person 1
    reporter: users[1] # Bob Wilson
  },
  {
    project: projects[0],
    title: 'Do this',
    description: 'Important task that needs attention',
    status: 'on_hold',
    priority: 'low',
    assigned_to: users[4], # Person 2
    reporter: users[2] # Alice Johnson
  },
  {
    project: projects[1],
    title: 'Update homepage design',
    description: 'The homepage needs a complete visual overhaul',
    status: 'active',
    priority: 'high',
    assigned_to: users[2], # Alice Johnson
    reporter: users[0] # Charlie Davis
  },
  {
    project: projects[2],
    title: 'Implement user authentication',
    description: 'Add login and registration functionality',
    status: 'on_hold',
    priority: 'critical',
    assigned_to: users[1], # Bob Wilson
    reporter: users[2] # Alice Johnson
  }
])

puts "Creating comments..."
Comment.create!([
  {
    issue: issues[1], # Fix a thing
    user: users[1], # Bob Wilson
    content: 'Ok, I have seen this issue, and will try to fix it'
  },
  {
    issue: issues[1], # Fix a thing
    user: users[3], # Person 1
    content: 'I need your feedback on some things go fix this'
  },
  {
    issue: issues[0], # qweqweqw
    user: users[0], # Charlie Davis
    content: 'This issue has been resolved successfully'
  },
  {
    issue: issues[4], # Update homepage design
    user: users[2], # Alice Johnson
    content: "I've started working on the mockups for the new design"
  },
  {
    issue: issues[4], # Update homepage design
    user: users[0], # Charlie Davis
    content: 'Great! Please make sure to follow the brand guidelines'
  }
])

puts "Database seeded successfully!"
puts "Created #{users.length} users"
puts "Created #{projects.length} projects"
puts "Created #{issues.length} issues"
puts "Created #{Comment.count} comments"
puts ""
puts "Seed data includes:"
puts "- Users: Charlie Davis, Bob Wilson, Alice Johnson, Person 1, Person 2, Person 3"
puts "- Projects: 1111, Website Redesign, Mobile App, API Migration"
puts "- Issues with various statuses and assignments"
puts "- Comments on several issues"
