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
        code = params[:code] || request.headers[:code] # Get code from headers or params
        begin
          user = verify_user!(code)
        rescue Octokit::NotFound
          render json: { error: { message: 'Invalid code' } }, status: :unauthorized # Code was invalid
          return
        rescue Octokit::Unauthorized
          render json: { error: { message: 'Github auth error' } }, status: :unauthorized # Bad authentication
          return
        end

        if code && user
          token = Tiddle.create_and_return_token(user, request)
          render json: { authentication_token: token }
        else
          render json: { error: { message: 'Auth error' } }, status: :unauthorized
        end
      end

      def destroy
        Tiddle.expire_token(current_user, request) if current_user
        render json: {}
      end

      private

      # this is invoked before destroy and we have to override it
      def verify_signed_out_user; end

      def verify_user!(code)
        access_token = code ? github_access.exchange_code_for_token(code) : nil # Verify github code and get token with it
        raise Octokit::Unauthorized if access_token[:access_token].nil?
        github_access_set_token(github_token: access_token[:access_token])
        github_user = github_access.user
        User.first_or_create(github_user)
      end

      def github_access
        @github_access ||= Octokit::Client.new client_id: Rails.application.secrets.oauth_github_id,
                                               client_secret: Rails.application.secrets.oauth_github_secret,
                                               scope: 'user:email'
      end

      def github_access_set_token(github_token:)
        @github_access.access_token = github_token
      end
    end
  end
end
