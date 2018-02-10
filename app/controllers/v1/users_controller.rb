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
=begin
  @api {get} /users Request user index
  @apiVersion 1.0.0
  @apiName GetUsers
  @apiPermission none
  @apiGroup Users
  @apiSuccess {Object} data
  @apiSuccess {Object[]} data.user User data
  @apiSuccess {String} data.user.github_id ID of user in source control
  @apiSuccess {String} data.user.login Login
  @apiSuccess {String} data.user.url_profile Url of the profile in source control
  @apiUse Pagination
  @apiUse NoContent
  @apiSuccessExample {json} Success
{
    "data": [
        {
            "github_id": "7500590",
            "login": "chargio",
            "url_profile": "https://github.com/chargio"
        }
    ],
    "meta": {
        "current_page": 1,
        "total_pages": 1,
        "total_count": 1
    }
}
=end
    def index
      logger.debug 'Providing all users'
      @users = User.all # TODO: Pagination
      @users = @users.where('github_login ILIKE ? ', "%#{params[:query]}%") if params[:query]
      @users = @users.order("#{params[:sort]} #{params[:order] || 'DESC'}") if params[:sort]
      if @users.count.positive?
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
    #
=begin
  @api {get} /users/:id Request user info
  @apiVersion 1.0.0
  @apiName GetUsersShow
  @apiPermission none
  @apiGroup Users
  @apiParam {Integer} id User unique ID.
  @apiSuccess {Object} data
  @apiSuccess {String} data.user.github_id Github numeric ID
  @apiSuccess {String} data.user.login Github login
  @apiSuccess {String} data.user.url_profile Profile link
  @apiSuccessExample {json} Success
{
    "data": {
        "github_id": "7500590",
        "login": "chargio",
        "url_profile": "https://github.com/chargio"
    }
}
  @apiError (No Content 404) UserNotFound User has not been found
  @apiError (No Content 404) {Integer} UserNotFound.status 404
  @apiError (No Content 404) {String} UserNotFound.code user_not_found
  @apiError (No Content 404) {String} UserNotFound.title Error title
  @apiError (No Content 404) {String} UserNotFound.Detail Additional detail on error
  @apiError (No Content 404) {Object} UserNotFound.extra
  @apiError (No Content 404) {String} UserNotFound.extra.username User ID

  @apiErrorExample {json} User not found
{
    "status": 404,
    "code": "user_not_found",
    "title": "This user is not in the database",
    "detail": "Maybe the id of user is wrong",
    "extra_info": {
        "username": "7500591"
    }
}
=end
    def show
      return unless  check_params_required(:id)
      logger.debug "Looking for user with github_login #{params[:id]}"
      @user = User.find_by(id: params[:id]) || User.find_by(github_login: params[:id])
      if @user
        return_response @user, :ok
      else
        render_error_exchange(:user_not_found, :not_found, { username: params[:id]})
      end
    end
  end
end
