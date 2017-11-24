module V1
  class ApiController < ApplicationController
    def version
      render json: { version: 0.1 }, status: :ok
    end
  end
end

