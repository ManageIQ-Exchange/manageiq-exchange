module V1
  ##
  # User controller
  # Provides information about the user
  ##
  class UsersController < ApplicationController
    def index
      @users = User.all
      render json: @users, status: :ok
    end
  end
end
