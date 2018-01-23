module V1
  ##
  # User controller
  # Provides information about the user
  ##
  class UsersController < ApiController
    # Get all Users function
    # query param to find a user with STR include no sensitive
    #
    # Return Users with only id, github_login and github_html_url with ok 200 code
    #     if param query expand is resources return all data with ok 200 code
    # Return a no_content 204 if there isn't any record
    #
    # users?query=<value> get users login include value
    def index
      logger.debug 'Providing all users'
      @users = User.all   # TODO: Pagination
      @users = @users.where('github_login like? or github_login like?', "%#{params[:query]}%", "%#{params[:query].downcase}%") if params[:query]

      total_users = @users.count
      if total_users.positive?
        logger.debug { "Returning #{total_users} Users" }
        # render json: @users, expand: params[:expand] == "resources",status: :ok
        return_response @users, :ok
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
      return unless  check_params_required(:id)
      logger.debug "Looking for user with github_login #{params[:id]}"
      @user = User.find_by(id: params[:id]) || User.find_by(github_login: params[:id])
      if @user
        return_response  @user,  :ok
      else
        render_error_exchange(:user_not_found, :not_found, { username: params[:id]})
      end
    end
  end
end
