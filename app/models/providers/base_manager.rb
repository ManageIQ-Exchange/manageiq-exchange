module Providers
  class BaseManager

    attr_reader :identifier, :provider

    SPIN_SCHEMA = Rails.application.config.spin_schema.freeze

    def initialize(identifier = 'github.com')
      @identifier = identifier
      @provider = get_provider(identifier)
      return @provider if @provider.kind_of? ErrorExchange
    end

    def translated_payload
      I18n.translate("errors.#{identifier}")
    end

    def get_connector
      case @provider[:type].downcase
      when 'github' then Providers::GithubManager.new(@provider)
      else ErrorExchange.new('errors.provider_type_not_supported', :bad_request, {})
      end
    end

    private

    def get_provider(identifier)
      Rails.application.secrets.oauth_providers.each do |provider|
        return provider if provider[:name] == identifier
      end
      return ErrorExchange.new('errors.provider_name_not_provided', :bad_request, {})
    end
  end
end