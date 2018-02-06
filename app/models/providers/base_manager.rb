module Providers
  class BaseManager

    attr_reader :identifier, :provider

    SPIN_SCHEMA = Rails.application.config.spin_schema.freeze

    def initialize(user)
      @identifier = user ? user.authentication_tokens.first.provider : nil
      @provider = get_provider(@identifier)
      @provider_token = user ? user.authentication_tokens.first.github_token : nil
      @provider_user = user || nil
    end

    def get_connector
      return @provider if @provider.kind_of? ErrorExchange
      case @provider[:type].downcase
      when 'github' then Providers::GithubManager.new(@provider)
      else ErrorExchange.new(:provider_name_not_provided, :bad_request, {})
      end
    end

    def validate_provider(identifier)
      pr = get_provider(identifier)
      @provider = pr
      return pr if pr.kind_of? ErrorExchange
      true
    end

    private

    def get_provider(identifier)
      Rails.application.secrets.oauth_providers.each do |provider|
        return provider if provider[:name] == identifier && provider[:enabled]
      end
      return ErrorExchange.new(:provider_name_not_provided, :bad_request, {})
    end
  end
end