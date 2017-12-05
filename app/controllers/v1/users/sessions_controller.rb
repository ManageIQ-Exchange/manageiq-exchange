module V1
  module Users
    ##
    # Sesssions Controller
    # Allows the user to create sessions, authenticating
    # Uses Devise + Tiddle
    # Authentication is done via tokens, using GitHub
    ##
    class SessionsController < Devise::SessionsController
      include GitHubHelper

      # before_action :configure_sign_in_params, only: [:create]
      def create
        logger.info 'Creating session, verifying code sent'
        code = params[:code] || request.headers[:code] # Get code from headers or params
        logger.warning 'Null code' if code.nil?
        begin
          token = verify_user!(code, request)
        rescue Octokit::NotFound
          logger.info 'User not found'
          render json: { error: { message: 'Invalid code' } }, status: :unauthorized # Code was invalid
          return
        rescue Octokit::Unauthorized
          logger.info 'User is not authorized'
          render json: { error: { message: 'Github auth error' } }, status: :unauthorized # Bad authentication
          return
        end
        # Return token
        if token
          logger.info 'Returning token'
          render json: { authentication_token: token }
        else
          logger.info 'Authentication error'
          render json: { error: { message: 'Auth error' } }, status: :unauthorized
        end
      end

      def destroy
        logger.info 'Destroying session'
        Tiddle.expire_token(current_user, request) if current_user
        render json: {}
      end

      private

      # this is invoked before destroy and we have to override it
      def verify_signed_out_user; end

      ###
      # verify_user
      # Verify user gets a code from the frontend application and verifies that the code correspond to a user
      # If the user does exist, it gets updated.
      # If the user does not exist, it gets created.
      #
      def verify_user!(code, request)
        logger.debug 'Verifying that the user code is valid and authenticating user'
        access_token = code ? github_access_exchange_code_for_token(code) : nil # Verify github code and get token with it
        raise Octokit::Unauthorized if access_token[:access_token].nil?
        github_user = github_access.user
        logger.debug 'Valid code, finding or creating user'
        user = User.first_or_create(github_user)
        logger.debug 'Creating user session token'
        token = Tiddle.create_and_return_token(user, request)
        authentication_token = Tiddle::TokenIssuer.build.find_token(user, token)
        authentication_token.update_columns(github_token: access_token[:access_token])
        token
      end
    end
  end
end
