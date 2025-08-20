class IssuesController < ApplicationController
  before_action :set_project
  before_action :set_issue, only: [:show, :update, :destroy]

  # GET /projects/:project_id/issues
  def index
    begin
      @issues = @project.issues.includes(:assigned_to, :reporter, :project)
                              .order(created_at: :desc)
      
      issues_data = @issues.map do |issue|
        issue.as_json(include_associations: true)
      end
      
      render json: issues_data
    rescue => e
      Rails.logger.error "Error fetching issues: #{e.message}"
      render_error('Failed to fetch issues')
    end
  end

  # GET /projects/:project_id/issues/:id
  def show
    begin
      issue_data = @issue.as_json(include_associations: true, include_comments: true)
      render json: issue_data
    rescue => e
      Rails.logger.error "Error fetching issue: #{e.message}"
      render_error('Failed to fetch issue')
    end
  end

  # POST /projects/:project_id/issues
  def create
    begin
      @issue = @project.issues.build(issue_params)
      
      # Validate reporter exists
      unless User.exists?(id: @issue.reporter_id)
        return render json: { error: 'Reporter not found' }, status: :bad_request
      end
      
      # Validate assigned user exists if provided
      if @issue.assigned_to_id && !User.exists?(id: @issue.assigned_to_id)
        return render json: { error: 'Assigned user not found' }, status: :bad_request
      end
      
      if @issue.save
        # Fetch the created issue with associations
        created_issue = Issue.includes(:assigned_to, :reporter, :project)
                            .find(@issue.id)
        
        render json: created_issue.as_json(include_associations: true), status: :created
      else
        render json: { 
          error: 'Validation failed',
          details: @issue.errors.full_messages 
        }, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "Error creating issue: #{e.message}"
      render_error('Failed to create issue')
    end
  end

  # PUT /projects/:project_id/issues/:id
  def update
    begin
      # Validate reporter exists if provided
      if issue_params[:reporter_id] && !User.exists?(id: issue_params[:reporter_id])
        return render json: { error: 'Reporter not found' }, status: :bad_request
      end
      
      # Validate assigned user exists if provided
      if issue_params[:assigned_to_id] && !User.exists?(id: issue_params[:assigned_to_id])
        return render json: { error: 'Assigned user not found' }, status: :bad_request
      end
      
      if @issue.update(issue_params)
        # Fetch the updated issue with associations
        updated_issue = Issue.includes(:assigned_to, :reporter, :project)
                            .find(@issue.id)
        
        render json: updated_issue.as_json(include_associations: true)
      else
        render json: { 
          error: 'Validation failed',
          details: @issue.errors.full_messages 
        }, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "Error updating issue: #{e.message}"
      render_error('Failed to update issue')
    end
  end

  # DELETE /projects/:project_id/issues/:id
  def destroy
    begin
      @issue.destroy!
      head :no_content
    rescue => e
      Rails.logger.error "Error deleting issue: #{e.message}"
      render_error('Failed to delete issue')
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_issue
    @issue = @project.issues.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:title, :description, :status, :priority, :assigned_to_id, :reporter_id, :due_date)
  end
end
