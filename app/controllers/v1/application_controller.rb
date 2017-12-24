module V1
  ##
  # User controller
  # Provides information about the user
  ##
  class ApplicationController < ActionController::API

    def return_response(collection, state = :ok, metadata = {}, role = nil)
      if check_params
        result = apply_filter(collection)
        result = select_page(collection) if collection.class.name.include?('ActiveRecord')
        args = {
            json: result,
            namespace: self.class.to_s.split("::").first.constantize,
            status: state,
            meta: meta_attributes(result, metadata),
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

    PARAMS = {
        "page":  "is_numeric?",
        "limit": "is_numeric?"
    }
    def check_params
      PARAMS.each do |param, method|
        if params[param]
          unless self.send(method,params[param])
            @error_object = "Param #{param} is wrong, #{method} failed"
            return false
          end
        end
      end
      return true
    end

    def apply_filter(collection)
      result = collection
      filter = controller_name.classify.constantize.column_names & params.keys
      sql = ""
      values = params.select { |x| filter.include?(x.to_s) }.values
      filter.each do |param_query|
        sql+=" AND " unless sql.empty?
        sql+="#{param_query} LIKE ?"
      end
      result = result.where(sql,*values) unless sql.empty?
      result
    end

    def select_page(collection)
      page = params["page"] || 1
      limit = params["limit"] || Rails.application.secrets.return_configuration[:items_per_page]
      collection.page(page).per(limit)
    end

    def expand_resources?
      params["expand"] == "resources"
    end

    def render_params
      render_options = {}
      render_options[:expand] = true if params["expand"] == "resources"
      render_options
    end

    #expects pagination!
    def meta_attributes(collection, extra_meta = {})
      meta = {}
      meta = meta.merge(meta_pagination(collection)) if collection.class.name.include?('ActiveRecord')
      meta.merge(extra_meta)
    end

    def meta_pagination(collection)
      next_page = previous_page = nil
      next_page = compile_page(URI(request.original_url), collection.next_page) if collection.total_pages > collection.current_page
      previous_page = compile_page(URI(request.original_url), collection.prev_page) if collection.current_page > 1 && collection.current_page < collection.total_pages
      meta = {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count

      }
      meta[:next_page] = collection.next_page if collection.next_page
      meta[:prev_page] = collection.prev_page if collection.prev_page
      meta[:href_previous_page] = previous_page if previous_page
      meta[:href_next_page] = next_page if next_page
      meta
    end

    def compile_page(uri, page)
      query_params  = Rack::Utils.parse_query(uri.query)
      query_params["page"] = page.to_s
      uri.query = Rack::Utils.build_query(query_params)
      uri.to_s
    end

    def is_numeric?(obj)
      obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end
  end
end
