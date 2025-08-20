require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module IssueTrackerBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments/, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Configure CORS
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV.fetch("FRONTEND_URL", "http://localhost:3000")
        resource "*",
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: true
      end
    end

    # Add database logging on startup (delayed to avoid connection issues)
    config.after_initialize do
      Rails.logger.info "🎉 Rails Application Started!"
      
      # Log environment variables for debugging
      Rails.logger.info "🔍 Environment Variables:"
      Rails.logger.info "  RAILS_ENV: #{ENV['RAILS_ENV']}"
      Rails.logger.info "  DATABASE_URL: #{ENV['DATABASE_URL']&.gsub(/\/\/.*@/, '//***@') || 'NOT SET'}"
      Rails.logger.info "  RAILS_MAX_THREADS: #{ENV['RAILS_MAX_THREADS']}"
      
      # Delay database check to allow connection to establish
      Thread.new do
        sleep 2 # Wait 2 seconds for database connection
        begin
          # Check database configuration
          Rails.logger.info "🔍 Checking database configuration..."
          db_config = ActiveRecord::Base.connection_db_config.configuration_hash
          Rails.logger.info "  Current adapter: #{db_config[:adapter]}"
          Rails.logger.info "  Current host: #{db_config[:host]}"
          Rails.logger.info "  Current database: #{db_config[:database]}"
          
          ActiveRecord::Base.connection.execute("SELECT 1")
          tables = ActiveRecord::Base.connection.tables
          Rails.logger.info "✅ Database Connection Established"
          Rails.logger.info "📋 Database Tables: #{tables.join(', ')}"
          Rails.logger.info "🔢 Total Tables: #{tables.count}"
          
          # Log table details with record counts
          tables.each do |table|
            begin
              count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first['count']
              Rails.logger.info "  📊 #{table}: #{count} records"
            rescue => e
              Rails.logger.info "  ❌ #{table}: Error counting records - #{e.message}"
            end
          end
          
          Rails.logger.info "🌐 Database URL: #{ENV['DATABASE_URL']&.gsub(/\/\/.*@/, '//***@')}"
          Rails.logger.info "🎯 Environment: #{Rails.env}"
        rescue => e
          Rails.logger.error "❌ Database Error: #{e.message}"
          Rails.logger.error "🔍 Check your DATABASE_URL environment variable"
          Rails.logger.error "🔍 Current connection config: #{ActiveRecord::Base.connection_db_config.configuration_hash.inspect}"
        end
      end
    end
  end
end
