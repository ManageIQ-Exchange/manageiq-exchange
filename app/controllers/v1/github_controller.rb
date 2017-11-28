module V1
  class GithubController < ApplicationController
    def access_token
      code = params[:code] || request.headers[:code]
      begin
        access_token = code ? github_access.exchange_code_for_token(code) : nil
      rescue Octokit::NotFound
        render json: { error: { message: "Invalid code"} }, status: :fail
        return
      end
      if access_token.try(:access_token)
        render json: { token: access_token[:access_token] }, status: :ok
      else
        if access_token[:error]
          render json: access_token, status: :fail
        else
          render json: { error: { message: "Need a post param code" }}, status: :fail
        end
      end
    end

    def user_info
      render json: { error: { message: "Need a post param code" }}, status: :fail unless request.headers["Token"]
      render json: github_token(request.headers["Token"]).user, status: :ok
    end

    private

    def github_access
      @github_access ||= Octokit::Client.new client_id: Rails.application.secrets.oauth_github_id, client_secret: Rails.application.secrets.oauth_github_secret, :scope => 'user:email'
    end

    def github_token(token)
      Octokit::Client.new(:access_token => token)
    end
  end
end

