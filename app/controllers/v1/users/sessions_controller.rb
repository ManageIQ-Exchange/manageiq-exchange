module V1
  module Users
    ##
    # Sesssions Controller
    # Allows the user to create sessions, authenticating
    # Uses Devise + Tiddle
    # Authentication is done via tokens, using GitHub
    ##
    class SessionsController < Devise::SessionsController
      # before_action :configure_sign_in_params, only: [:create]
      def create
        logger.info 'Creating session, verifying code'
        code = params[:code] || request.headers[:code] # Get code from headers or params
        begin
          user = verify_user!(code)
        rescue Octokit::NotFound
          logger.info 'User not found'
          render json: { error: { message: 'Invalid code' } }, status: :unauthorized # Code was invalid
          return
        rescue Octokit::Unauthorized
          logger.info 'User is not authorized'
          render json: { error: { message: 'Github auth error' } }, status: :unauthorized # Bad authentication
          return
        end

        if code && user
          logger.debug 'Creating user session token'
          token = Tiddle.create_and_return_token(user, request)
          render json: { authentication_token: token }
        else
          logger.info 'Authentcation error'
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
      def verify_user!(code)
        logger.debug 'Verifying that the user code is valid and authenticating user'
        access_token = code ? github_access.exchange_code_for_token(code) : nil # Verify github code and get token with it
        raise Octokit::Unauthorized if access_token[:access_token].nil?
        github_access_set_token(github_token: access_token[:access_token])
        github_user = github_access.user
        logger.debug 'Valid code, finding or creating user'
        User.first_or_create(github_user)
      end

      ###
      # github_access:
      # Generates access credentials for the user (new or stored)
      #
      def github_access
        @github_access ||= Octokit::Client.new client_id: Rails.application.secrets.oauth_github_id,
                                               client_secret: Rails.application.secrets.oauth_github_secret,
                                               scope: 'user:email'
      end

      ###
      # github_access_set_token(github_token: string - mandatory)
      # Associates a token to github_access for authentication
      #
      def github_access_set_token(github_token:)
        @github_access.access_token = github_token
      end
    end
  end
end
