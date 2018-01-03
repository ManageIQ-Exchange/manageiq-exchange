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

    ##
    # Accepts a code and return a token hash
    # @param code [String]
    # @return [String]
    #

    def exchange_code_for_token!(code)
      github_token = @github_access.exchange_code_for_token(code)
      @github_access.access_token = github_token[:access_token] unless github_token[:error] || github_token.nil?
      github_token
    end

    #
    # Returns the user
    # @return user [SourceControlUser]
    #
    def user
      @github_access.user if @github_access.user_authenticated?
    end

    #
    # Check if a spin is a candidate
    # @return boolean
    #

    def candidate_spin?(full_name)
      begin
        @github_access.contents(full_name, path: '/.manageiq-spin', accept: 'application/vnd.github.raw')
      rescue Octokit::NotFound
        nil
      end
    end

    #
    # Returns metadata from the repo or nil
    # @param full_name [String] Full name of repo
    # @return [metadata_raw, metadata_json]
    def metadata(full_name)
      begin
        @github_access.contents(full_name, path: '/metadata.yml', accept: 'application/vnd.github.raw')
      rescue Octokit::NotFound
        nil
      end
    end

    #
    # Returns readme decoded
    # @param full_name [String] Full name of repo
    def readme(full_name)
      @github_access.readme(full_name, accept: 'application/vnd.github.raw')
    rescue Octokit::NotFound
      nil
    end

    def repos(user:, github_token:)
      @github_access.access_token ||= github_token
      @github_access.repos(user)
    end
  end

  # Creates an instance access_control_server to be reused by the application
  # @return [SourceControlServer]
  def source_control_server
    @source_control_server ||= SourceControlServer.new
  end
end
