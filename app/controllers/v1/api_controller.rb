module V1
  VERSION = 1.0
  class ApiController < ApplicationController
    def version
      render json: { data: { version: VERSION } }, status: :ok
    end
  end
end

