module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define('User', {
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
        len: [2, 100]
      }
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true
      }
    },
    password: {
      type: DataTypes.STRING,
      allowNull: true // For demo purposes, making password optional
    },
    avatar_url: {
      type: DataTypes.STRING,
      allowNull: true
    },
    is_active: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    }
  }, {
    tableName: 'users',
    underscored: true,
    timestamps: true,
    defaultScope: {
      attributes: { exclude: ['password'] }
    },
    scopes: {
      withPassword: {
        attributes: {}
      }
    }
  });

  User.associate = function(models) {
    User.hasMany(models.Issue, {
      foreignKey: 'assigned_to_id',
      as: 'assigned_issues'
    });
    User.hasMany(models.Issue, {
      foreignKey: 'reporter_id',
      as: 'reported_issues'
    });
    User.hasMany(models.Comment, {
      foreignKey: 'user_id',
      as: 'comments'
    });
  };

  return User;
};
