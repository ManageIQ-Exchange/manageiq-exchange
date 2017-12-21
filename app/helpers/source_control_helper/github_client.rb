module SourceControlHelper
  # SourceControlHelper::GithubClient Client for GitHub requests
  class GithubClient
    attr_reader :server_type

    def initialize
      Rails.logger.info 'Generating new connection to Source Control'

      github_url = URI::HTTPS.build(host: Rails.application.secrets.github_server, path: "/api/#{Rails.application.secrets.github_version}")

      opts = {
        api_endpoint:       github_url.to_s,
        connection_options: { ssl: { verify: Rails.application.secrets.github_verify } },
        client_id:          Rails.application.secrets.oauth_github_id,
        client_secret:      Rails.application.secrets.oauth_github_secret,
        scope:              'user:email'
      }

      @github_access ||= Octokit::Client.new opts

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
    # Returns metadata from the repo or nil
    # @param full_name [String] Full name of repo
    # @return [metadata_raw, metadata_json]

    def metadata(full_name)
      begin
        metadata_raw = @github_access.contents(full_name, path: '/metadata.yml', accept: 'application/vnd.github.raw')
      rescue Octokit::NotFound
        nil
      end

      begin
        metadata_json = JSON.parse(JSON.dump(YAML.safe_load(metadata_raw)))
        unless metadata_json.nil?
          JSON::Validator.validate!(SPIN_SCHEMA, metadata_json)
          return [metadata_raw, metadata_json]
        end
        nil
      rescue TypeError, JSON::ParserError, JSON::Schema::ValidationError
        nil # There has been some kind of error while parsing, so it is not valid
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
<<<<<<< HEAD
end
=======
end
>>>>>>> GitHub Enterprise Support
