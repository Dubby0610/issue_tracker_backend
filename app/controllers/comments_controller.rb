class CommentsController < ApplicationController
  before_action :set_issue, only: [:index, :create]
  before_action :set_comment, only: [:update, :destroy]

  # GET /projects/:project_id/issues/:issue_id/comments
  def index
    begin
      @comments = @issue.comments.includes(:user).chronological
      
      comments_data = @comments.map do |comment|
        comment.as_json(include_user: true)
      end
      
      render json: comments_data
    rescue => e
      Rails.logger.error "Error fetching comments: #{e.message}"
      render_error('Failed to fetch comments')
    end
  end

  # POST /projects/:project_id/issues/:issue_id/comments
  def create
    begin
      @comment = @issue.comments.build(comment_params)
      
      # Validate user exists
      unless User.exists?(id: @comment.user_id)
        return render json: { error: 'User not found' }, status: :bad_request
      end
      
      if @comment.save
        # Fetch the created comment with user information
        created_comment = Comment.includes(:user).find(@comment.id)
        render json: created_comment.as_json(include_user: true), status: :created
      else
        render json: { 
          error: 'Validation failed',
          details: @comment.errors.full_messages 
        }, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "Error creating comment: #{e.message}"
      render_error('Failed to create comment')
    end
  end

  # PUT /comments/:id
  def update
    begin
      if @comment.update(comment_update_params)
        # Fetch the updated comment with user information
        updated_comment = Comment.includes(:user).find(@comment.id)
        render json: updated_comment.as_json(include_user: true)
      else
        render json: { 
          error: 'Validation failed',
          details: @comment.errors.full_messages 
        }, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "Error updating comment: #{e.message}"
      render_error('Failed to update comment')
    end
  end

  # DELETE /comments/:id
  def destroy
    begin
      @comment.destroy!
      head :no_content
    rescue => e
      Rails.logger.error "Error deleting comment: #{e.message}"
      render_error('Failed to delete comment')
    end
  end

  private

  def set_issue
    project = Project.find(params[:project_id])
    @issue = project.issues.find(params[:issue_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id, :is_internal)
  end

  def comment_update_params
    params.require(:comment).permit(:content, :is_internal)
  end
end
