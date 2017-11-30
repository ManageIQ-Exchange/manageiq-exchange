module V1
  VERSION = 1.0
  ##
  # API Controller
  # Provides information about the API
  ##
  class ApiController < ApplicationController
    def version
      render json: { data: { version: VERSION } }, status: :ok
    end
  end
end
