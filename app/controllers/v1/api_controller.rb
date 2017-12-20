module V1
  ##
  # API Controller
  # Provides information about the API
  ##
  class ApiController < ApplicationController
    def version
      logger.debug 'Creating session, verifying code'
      return_response json: { version: Rails.application.config.api_version } , status: :ok
    end
  end
end
