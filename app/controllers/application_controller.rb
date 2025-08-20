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
      environment: Rails.env,
      database: get_database_status
    }
  end

  # Database info endpoint
  def db_info
    render json: {
      status: 'OK',
      timestamp: Time.current.iso8601,
      environment: Rails.env,
      database: get_detailed_database_info
    }
  end

  private

  def get_database_status
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      tables = ActiveRecord::Base.connection.tables
      {
        connected: true,
        tables: tables,
        table_count: tables.count,
        record_counts: get_record_counts(tables)
      }
    rescue => e
      {
        connected: false,
        error: e.message
      }
    end
  end

  def get_record_counts(tables)
    counts = {}
    tables.each do |table|
      begin
        count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first['count']
        counts[table] = count
      rescue => e
        counts[table] = "Error: #{e.message}"
      end
    end
    counts
  end

  def get_detailed_database_info
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      tables = ActiveRecord::Base.connection.tables
      
      # Get detailed table information
      table_details = {}
      tables.each do |table|
        begin
          count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first['count']
          columns = ActiveRecord::Base.connection.columns(table).map(&:name)
          table_details[table] = {
            record_count: count,
            columns: columns,
            column_count: columns.count
          }
        rescue => e
          table_details[table] = {
            error: e.message
          }
        end
      end
      
      {
        connected: true,
        tables: tables,
        table_count: tables.count,
        table_details: table_details,
        database_url: ENV['DATABASE_URL']&.gsub(/\/\/.*@/, '//***@'),
        adapter: ActiveRecord::Base.connection.adapter_name,
        database_name: ActiveRecord::Base.connection.database_name
      }
    rescue => e
      {
        connected: false,
        error: e.message,
        database_url: ENV['DATABASE_URL']&.gsub(/\/\/.*@/, '//***@')
      }
    end
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
