###
# Source Control Helper
# Helper to address the need to isolate the connection from the actual API calls
#
#

module SourceControlHelper
  #
  # Class that represents a Source Control Server upstream
  #
  #
  class SourceControlServer
    attr_reader :server_type
    def initialize
      Rails.logger.info 'Generating new connection to Source Control'
      @github_access ||= Octokit::Client.new client_id: Rails.application.secrets.oauth_github_id,
                                             client_secret: Rails.application.secrets.oauth_github_secret,
                                             scope: 'user:email'
      @server_type = 'GitHub'
    end

    def exchange_token_for_code!(code)
      github_token = @github_access.exchange_code_for_token(code)
      raise Octokit::Unauthorized if github_token[:error] || github_token.nil?
      @github_access.access_token = github_token[:access_token]
      github_token
    end

    def user
      @github_acess.user
    end
  end


  # Returns a connection to a source control
  # @return [SourceControl]
  #
  def sc_connection
    github_access # if GitHub
  end



  #
  # Get access token from code.
  #
  # Applications need to identify git the source control helper and return a code
  #
  #
  # That code will be authenticated again against the source control server to get a code
  # @param code [String]
  # @return [String]
  #
  def sc_exchange_token_for_code(code)
    github_access_exchange_code_for_token(code) # If GitHub
  end

  #
  # Private methods: to access the source control
  #

  #
  # GitHub access connection
  #
  protected

  def github_access
    @github_access ||= Octokit::Client.new client_id: Rails.application.secrets.oauth_github_id,
                                           client_secret: Rails.application.secrets.oauth_github_secret,
                                           scope: 'user:email'
  end

  #
  # GitHub method to exchange code and token
  #

  def github_access_exchange_code_for_token(code)
    github_token = github_access.exchange_code_for_token(code)
    raise Octokit::Unauthorized if github_token[:error]
    @github_access.access_token = github_token[:access_token]
    github_token
  end
end
