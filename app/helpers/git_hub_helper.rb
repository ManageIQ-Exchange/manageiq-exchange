module GitHubHelper
  ###
  # github_access:
  # Generates access credentials for the user (new or stored)
  #
  def github_access
    @github_access ||= Octokit::Client.new client_id: Rails.application.secrets.oauth_github_id,
                                           client_secret: Rails.application.secrets.oauth_github_secret,
                                           scope: 'user:email'
  end

  def github_access_exchange_code_for_token(code)
    github_token = github_access.exchange_code_for_token(code)
    raise Octokit::Unauthorized if github_token[:error]
    @github_access.access_token = github_token[:access_token]
    github_token
  end
end