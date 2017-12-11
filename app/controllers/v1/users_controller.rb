module V1
  ##
  # User controller
  # Provides information about the user
  ##
  class UsersController < ApplicationController

    # Get all Users function
    #
    # Return Users with onky id, github_login and github_html_url with ok 200 code
    #     if param query expand is resources return all data with ok 200 code
    # Return a no_content 204 if there isn't any record
    #
    def index
      logger.debug 'Providing all users'
      @users = User.all
      if @users.count>0
        logger.debug { "Returning #{@users.count} Users" }
        @users = @users.select(:id, :github_login, :github_html_url) unless params[:expand] == "resources"
        render json:  @users, status: :ok
      else
        render status: :no_content
      end
    end

    # Show User function
    #
    # Return User find by id or github_login with a ok 200 code
    # Return a error message with a not_found 404 code
    #
    def show
      logger.debug "Looking for user with github_login #{params[:id]}"
      @user = User.find_by(id: params[:id]) || User.find_by(github_login: params[:id])
      if @user
        render json: @user, status: :ok
      else
        render json: { error: "Not user found with #{params[:id]}"}, status: :not_found
      end
    end
  end
end
