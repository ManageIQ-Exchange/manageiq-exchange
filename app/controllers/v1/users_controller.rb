module V1
  ##
  # User controller
  # Provides information about the user
  ##
  class UsersController < ApplicationController
    def index
      logger.debug 'Providing all users'
      @users = User.all
      logger.debug { "Returning #{@users.count} Users" }
      render json: { data: @users }, status: :ok
    end
  end
end
