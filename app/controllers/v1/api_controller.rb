module V1
  ##
  # API Controller
  # Provides information about the API
  ##
  class ApiController < ApplicationController
    def version
      logger.debug 'Creating session, verifying code'
      render json: { data: { version: Rails.application.config.api_version } }, status: :ok
    end
  end
end
