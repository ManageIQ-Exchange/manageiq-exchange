module V1
  ##
  # API Controller
  # Provides information about the API
  ##
  class ApiController < ActionController::API

    include Parameters
    include Pagination
    include Metadata

    def version
      logger.debug 'Creating session, verifying code'
      render json: { data: { version: Rails.application.config.api_version } } , status: :ok
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
