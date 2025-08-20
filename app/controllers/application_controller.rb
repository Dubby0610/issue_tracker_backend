class ApplicationController < ActionController::API
  # Global error handling
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  # Health check endpoint
  def health
    render json: { 
      status: 'OK', 
      timestamp: Time.current.iso8601,
      environment: Rails.env
    }
  end

  private

  def render_not_found(exception)
    render json: { 
      error: 'Resource not found',
      message: exception.message 
    }, status: :not_found
  end

  def render_unprocessable_entity(exception)
    render json: { 
      error: 'Validation failed',
      details: exception.record.errors.full_messages 
    }, status: :unprocessable_entity
  end

  def render_bad_request(exception)
    render json: { 
      error: 'Bad request',
      message: exception.message 
    }, status: :bad_request
  end

  def render_error(message, status = :internal_server_error)
    render json: { 
      error: message,
      timestamp: Time.current.iso8601
    }, status: status
  end
end
