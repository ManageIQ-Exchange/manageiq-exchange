module V1
  @version ||= Rails.application.config.api_version
  ##
  # API Controller
  # Provides information about the API
  ##
  class ApiController < ApplicationController
    def version
      render json: { data: { version: @version } }, status: :ok
    end
  end
end
