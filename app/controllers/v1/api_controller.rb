module V1
  ##
  # API Controller
  # Provides information about the API
  ##
  class ApiController < ApplicationController

    include Parameters
    include Pagination
    include Metadata

=begin
  @api {get} / Request version information
  @apiVersion 1.0.0
  @apiName GetApi
  @apiPermission none
  @apiGroup Api
  @apiSuccess {String} version Version of the API
  @apiSuccess {Object[]} providers Authentication endpoints
  @apiSuccess {String=["github"]} providers.type Type of provider oauth
  @apiSuccess {Boolean} providers.enabled Whether the provide is enabled or not
  @apiSuccess {String} providers.id_application Id of the application in the oauth provider
  @apiSuccess {String} providers.server Server Address
  @apiSuccess {String} providers.version API Prefix
  @apiSuccess {Boolean} providers.verify Does it need verify?
=end
    def version
      logger.debug 'Creating session, verifying code'
      providers = {}
      Rails.application.secrets.oauth_providers.each do |pr|
        pro = pr.clone
        pro.delete(:secret)
        name = pro.delete(:name)
        providers[name] = pro if pro[:enabled]
      end
      render json: { data: { version: Rails.application.config.api_version, providers: providers } }, status: :ok
    end

    def return_response(collection, state = :ok, metadata = {}, role = nil)
      if check_params
        result = select_page(collection) if collection.class.name.include?('ActiveRecord')
        args = {
            json: result || collection,
            namespace: self.class.to_s.split("::").first.constantize,
            status: state,
            meta: meta_attributes(result || collection, metadata),
            adapter: :json,
            root: 'data'
        }
        args[:expand] = true if expand_resources?
        args[role.to_sym] = true if role
        render *[args]
      else
        render json: { errors: @error_object }
      end
    end

    def check_params_required(*values)
      values.each do |param|
        unless params.has_key? param.to_s
          render_error_exchange(:param_not_found, :bad_request, {param_required: "You need to set param #{param.to_s}"})
          return false
        end
      end
      true
    end

    protected

    def render_error_exchange(identifier, status, extra_info = nil)
      render json: ErrorExchange.new(identifier, status, extra_info), status: status
    end
  end
end
