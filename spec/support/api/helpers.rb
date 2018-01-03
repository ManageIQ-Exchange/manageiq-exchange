#
# For testing REST API via Rspec requests
#

module Spec
  module Support
    module Api
      module Helpers
        def api_basic_authorize(*identifiers)
          token_class = @user.association(:authentication_tokens).klass
          token, token_body = Devise.token_generator.generate(token_class, :body)

          @user.authentication_tokens
              .create! body: token_body,
                       last_used_at: DateTime.current,
                       ip_address: '0.0.0.0',
                       user_agent: 'Travis'
          request_headers["X-USER-TOKEN"] = token
          request_headers["X-USER-ID"] = @user.github_id
        end
      end
    end
  end
end