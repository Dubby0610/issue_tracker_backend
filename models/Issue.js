module.exports = (sequelize, DataTypes) => {
  const Issue = sequelize.define('Issue', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    project_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'projects',
        key: 'id'
      }
    },
    title: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notEmpty: true,
        len: [3, 500]
      }
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    status: {
      type: DataTypes.ENUM('active', 'on_hold', 'resolved', 'closed'),
      defaultValue: 'active',
      allowNull: false
    },
    priority: {
      type: DataTypes.ENUM('low', 'medium', 'high', 'critical'),
      defaultValue: 'medium',
      allowNull: false
    },
    assigned_to_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'users',
        key: 'id'
      }
    },
    reporter_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id'
      }
    },
    due_date: {
      type: DataTypes.DATE,
      allowNull: true
    }
  }, {
    tableName: 'issues',
    underscored: true,
    timestamps: true
  });

  Issue.associate = function(models) {
    Issue.belongsTo(models.Project, {
      foreignKey: 'project_id',
      as: 'project'
    });
    Issue.belongsTo(models.User, {
      foreignKey: 'assigned_to_id',
      as: 'assigned_to'
    });
    Issue.belongsTo(models.User, {
      foreignKey: 'reporter_id',
      as: 'reporter'
    });
    Issue.hasMany(models.Comment, {
      foreignKey: 'issue_id',
      as: 'comments',
      onDelete: 'CASCADE'
    });
  };

  return Issue;
};
