module.exports = (sequelize, DataTypes) => {
  const Comment = sequelize.define('Comment', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    issue_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'issues',
        key: 'id'
      }
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id'
      }
    },
    content: {
      type: DataTypes.TEXT,
      allowNull: false,
      validate: {
        notEmpty: true,
        len: [1, 5000]
      }
    },
    is_internal: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    }
  }, {
    tableName: 'comments',
    underscored: true,
    timestamps: true
  });

  Comment.associate = function(models) {
    Comment.belongsTo(models.Issue, {
      foreignKey: 'issue_id',
      as: 'issue'
    });
    Comment.belongsTo(models.User, {
      foreignKey: 'user_id',
      as: 'user'
    });
  };

  return Comment;
};
