class HealthController < ApplicationController
  def liveness
    render json: { status: "alive" }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def readiness
    status = { database: check_database, status: "ready" }

    render json: status, status: :ok
  rescue StandardError => e
    Rails.logger.error("Health check failed: #{e.message}")
    render json: { error: e.message }, status: :service_unavailable
  end

  private

  def check_database
    ActiveRecord::Base.connection.execute("SELECT 1")
    "connected"
  rescue StandardError => e
    Rails.logger.error("Database health check failed: #{e.message}")
    "disconnected"
  end

  def solid_queue_worker?
    ENV["SOLID_QUEUE_WORKER"] == "true"
  end
end
