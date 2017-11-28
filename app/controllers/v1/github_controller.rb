module V1
  class GithubController < ApplicationController
    def access_token
      access_token = params[:code] ? github_access.exchange_code_for_token(params[:code]) : nil
      if access_token[:access_token]
        render json: { token: access_token[:access_token] }, status: :ok
      else
        render json: { error: { message: "Need a post param code" }}, status: :fail unless params[:code]
      end
    end

    def user_info
      render json: { error: { message: "Need a post param code" }}, status: :fail unless request.headers["Token"]
      render json: github_token(request.headers["Token"]).user, status: :ok
    end

    private

    def github_access
      @github_access ||= Octokit::Client.new client_id: ENV["GITHUB_OAUTH_ID"], client_secret: ENV["GITHUB_OAUTH_SECRET"], :scope => 'user:email'
    end

    def github_token(token)
      Octokit::Client.new(:access_token => token)
    end
  end
end

