module Providers
  class GithubManager < BaseManager
    attr_reader :server_type, :github_access

    def initialize(provider)
      Rails.logger.info 'Generating new connection to Source Control'

      github_url = provider[:enterprise] ? URI::HTTPS.build(host: provider[:server],path: "api/#{provider[:version]}") : URI::HTTPS.build(host: provider[:server])
      github_url = URI::HTTPS.build(host: provider[:server])

      opts = {
          api_endpoint:       github_url.to_s,
          connection_options: { ssl: { verify: provider[:verify] } },
          client_id:          provider[:id_application],
          client_secret:      provider[:secret],
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
        return ErrorExchange.new("errors.spin_get_metadata_from_provider", nil, {})
      end

      begin
        metadata_json = JSON.parse(JSON.dump(YAML.safe_load(metadata_raw)))
        unless metadata_json.nil?
          JSON::Validator.validate!(SPIN_SCHEMA, metadata_json)
          return [metadata_raw, metadata_json]
        end
        return ErrorExchange.new("errors.spin_metadata_to_json", nil, {})
      rescue TypeError, JSON::ParserError, JSON::Schema::ValidationError => e
        return ErrorExchange.new("errors.spin_error_metadata", nil, {error: e.to_json})
      end
    end

    #
    # Returns releases from the repo or nil
    # @param full_name [String] Full name of repo
    # @return [metadata_raw, metadata_json]
    def releases(full_name)
      begin
        @github_access.releases(full_name)
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
end