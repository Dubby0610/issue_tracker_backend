class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy]

  # GET /projects
  def index
    begin
      @projects = Project.includes(:issues).order(updated_at: :desc)
      
      projects_data = @projects.map do |project|
        project.as_json.merge('issues_count' => project.issues.count)
      end
      
      render json: projects_data
    rescue => e
      Rails.logger.error "Error fetching projects: #{e.message}"
      render_error('Failed to fetch projects')
    end
  end

  # GET /projects/:id
  def show
    begin
      project_data = @project.as_json.merge('issues_count' => @project.issues.count)
      render json: project_data
    rescue => e
      Rails.logger.error "Error fetching project: #{e.message}"
      render_error('Failed to fetch project')
    end
  end

  # POST /projects
  def create
    begin
      @project = Project.new(project_params)
      
      if @project.save
        render json: @project, status: :created
      else
        render json: { 
          error: 'Validation failed',
          details: @project.errors.full_messages 
        }, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "Error creating project: #{e.message}"
      render_error('Failed to create project')
    end
  end

  # PUT /projects/:id
  def update
    begin
      if @project.update(project_params)
        render json: @project
      else
        render json: { 
          error: 'Validation failed',
          details: @project.errors.full_messages 
        }, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "Error updating project: #{e.message}"
      render_error('Failed to update project')
    end
  end

  # DELETE /projects/:id
  def destroy
    begin
      @project.destroy!
      head :no_content
    rescue => e
      Rails.logger.error "Error deleting project: #{e.message}"
      render_error('Failed to delete project')
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :status, :start_date, :end_date)
  end
end
