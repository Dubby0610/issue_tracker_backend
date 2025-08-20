class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /users
  def index
    begin
      @users = User.active.order(:name)
      render json: @users.as_json(only: [:id, :name, :email, :avatar_url, :created_at])
    rescue => e
      Rails.logger.error "Error fetching users: #{e.message}"
      render_error('Failed to fetch users')
    end
  end

  # GET /users/:id
  def show
    begin
      user_data = @user.as_json(
        only: [:id, :name, :email, :avatar_url, :created_at],
        include: {
          assigned_issues: { only: [:id, :title, :status] },
          reported_issues: { only: [:id, :title, :status] }
        }
      )
      render json: user_data
    rescue => e
      Rails.logger.error "Error fetching user: #{e.message}"
      render_error('Failed to fetch user')
    end
  end

  # POST /users
  def create
    begin
      @user = User.new(user_params)
      
      if @user.save
        render json: @user.as_json(only: [:id, :name, :email, :avatar_url, :created_at]), 
               status: :created
      else
        render json: { 
          error: 'Validation failed',
          details: @user.errors.full_messages 
        }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique => e
      render json: { error: 'Email already exists' }, status: :bad_request
    rescue => e
      Rails.logger.error "Error creating user: #{e.message}"
      render_error('Failed to create user')
    end
  end

  # PUT /users/:id
  def update
    begin
      if @user.update(user_params)
        render json: @user.as_json(only: [:id, :name, :email, :avatar_url, :created_at])
      else
        render json: { 
          error: 'Validation failed',
          details: @user.errors.full_messages 
        }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique => e
      render json: { error: 'Email already exists' }, status: :bad_request
    rescue => e
      Rails.logger.error "Error updating user: #{e.message}"
      render_error('Failed to update user')
    end
  end

  # DELETE /users/:id (soft delete)
  def destroy
    begin
      @user.soft_delete!
      head :no_content
    rescue => e
      Rails.logger.error "Error deactivating user: #{e.message}"
      render_error('Failed to deactivate user')
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar_url)
  end
end
