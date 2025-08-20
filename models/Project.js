module.exports = (sequelize, DataTypes) => {
  const Project = sequelize.define('Project', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notEmpty: true,
        len: [2, 200]
      }
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    status: {
      type: DataTypes.ENUM('active', 'on_hold', 'completed', 'archived'),
      defaultValue: 'active',
      allowNull: false
    },
    start_date: {
      type: DataTypes.DATE,
      allowNull: true
    },
    end_date: {
      type: DataTypes.DATE,
      allowNull: true
    }
  }, {
    tableName: 'projects',
    underscored: true,
    timestamps: true
  });

  Project.associate = function(models) {
    Project.hasMany(models.Issue, {
      foreignKey: 'project_id',
      as: 'issues',
      onDelete: 'CASCADE'
    });
  };

  return Project;
};
