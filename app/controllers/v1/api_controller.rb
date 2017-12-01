module V1
  ##
  # API Controller
  # Provides information about the API
  ##
  class ApiController < ApplicationController
    def version
      render json: { data: { version: Rails.application.config.api_version } }, status: :ok
    end
  end
end
