module V1
  class ApiController
    ###
    # Pagination request module
    #
    ##
=begin
  @apiDefine Pagination Pagination
  @apiSuccess {Object} meta Meta
  @apiSuccess {Integer} meta.pagination.current_page Current page in pagination
  @apiSuccess {Integer} meta.pagination.total_pages Total number of pages
  @apiSuccess {Integer} meta.pagination.total_count Total number of elements
  @apiVersion 1.0.0
=end
    module Pagination
      # Get the specific page collection with limit option.
      #
      # @param collection [ActiveRecord] the result of the query
      # @return [ActiveRecord] the result of the specific page
      def select_page(collection)
        page = params['page'] || 1
        # The value of the param of the request or the configuration value
        limit = params['limit'] || Rails.application.secrets.return_configuration[:items_per_page]
        # The result por the page *page* with a limit of *limit*
        collection.page(page).per(limit)
      end

      # Compile the page uri for request.
      #
      # @param uri [URI] the URI request for the client
      # @param page [integer] the number of the page requested
      # @return [string] the uri for the page **page**
      def compile_page(uri, page)
        # Get the query params of the URI request
        query_params = Rack::Utils.parse_query(uri.query)
        # Change the param page for the *page* param
        query_params['page'] = page.to_s
        # Change the uri query with the new data
        uri.query = Rack::Utils.build_query(query_params)
        # Return the URI in String format
        uri.to_s
      end
    end
  end
end
