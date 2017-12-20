module V1
  module Users
    ##
    # Sesssions Controller
    # Allows the user to create sessions, authenticating
    # Uses Devise + Tiddle
    # Authentication is done via tokens, using GitHub
    ##
    class SessionsController < Devise::SessionsController
      include SourceControlHelper

      # before_action :configure_sign_in_params, only: [:create]
      def create
        user = User.find_by(id: request.headers["X-USER-ID"])
        token = request.headers["X-USER-CODE"]
        if Tiddle::TokenIssuer.build.find_token(user, token)
          render json: { data: { user: user, authentication_token: token } }
          return
        end

        logger.info 'Creating session, verifying code sent'
        code = params[:code] || request.headers[:code] # Get code from headers or params
        if code.nil?
          logger.warn 'Null code, impossible to authenticate'
          return_response json: { error: { message: 'Invalid code' } }, status: :not_acceptable
          return
        end
        begin
          user, token = verify_user!(code, request)
        rescue Octokit::NotFound
          logger.info 'User not found'
          return_response json: { error: { message: 'Invalid code' } }, status: :not_found # Code was invalid
          return
        rescue Octokit::Unauthorized
          logger.info 'User is not authorized'
          render json: { error: { message: 'Github auth error' } }, status: :unauthorized # Bad authentication
          return
        end
        # Return token
        if token
          logger.info 'Returning user info and token'
          render json: { data: { user: user, authentication_token: token } }
        else
          logger.info 'Authentication error'
          render json: { error: { message: 'Auth error' } }, status: :unauthorized
        end
      end

      def destroy
        logger.info 'Destroying session'
        Tiddle.expire_token(current_user, request) if current_user
        return_response json: {}
      end

      private

      # this is invoked before destroy and we have to override it
      def verify_signed_out_user; end

      ###
      #
      # Gets a code from the frontend application and verifies that the code correspond to a user.
      #
      # * If the user does exist, it gets updated.
      # * If the user does not exist, it gets created.
      #
      # @param code [String] Code received from the front-end for authentication
      # @return user [User]
      # @return token [String]
      #
      def verify_user!(code, request)
        logger.debug 'Verifying that the user code is valid and authenticating user'
        connection = source_control_server
        access_token = code ? connection.exchange_code_for_token!(code) : nil # Verify github code and get token with it
        raise Octokit::NotFound unless access_token[:error].nil?
        github_user = connection.user
        raise Octokit::Unauthorized if github_user.nil?
        logger.debug "Valid code, finding or creating user #{github_user.login}"
        user = User.return_user(github_user)
        logger.debug 'Creating user session token'
        token = Tiddle.create_and_return_token(user, request)
        authentication_token = Tiddle::TokenIssuer.build.find_token(user, token)
        authentication_token.update(github_token: access_token[:access_token])
        [user, token]
      end
    end
  end
end
