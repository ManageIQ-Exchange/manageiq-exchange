module V1
  class ApiController
    ###
    # Metadata request module
    #
    ##
    module Metadata
      # Generate metadata information for request.
      #
      # @param collection [ActiveRecord] the result of the query
      # @param extra_meta [Hash] information extra for metadata
      # @return [Hash] the metadata for the request response
      def meta_attributes(collection, extra_meta = {})
        meta = {}
        meta = meta.merge(meta_pagination(collection)) if collection.class.name.include?('ActiveRecord')
        # Merge the metadata result with the extra metadata
        meta.merge(extra_meta)
      end

      # Generate metadata pagination for request.
      #
      # @param collection [ActiveRecord] the result of the query
      # @return [Hash] the metadata pagination for the request response
      def meta_pagination(collection)
        next_page = previous_page = nil
        # Generate the link to the next page
        next_page = compile_page(URI(request.original_url), collection.next_page) if collection.total_pages > collection.current_page
        # Generate the link to the previous page
        previous_page = compile_page(URI(request.original_url), collection.prev_page) if collection.current_page > 1 && collection.current_page < collection.total_pages
        # Current page of the response
        # Total pages of the query
        # Total records of the query
        meta = {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count

        }
        # Next number page
        meta[:next_page] = collection.next_page if collection.next_page
        # Previous number page
        meta[:prev_page] = collection.prev_page if collection.prev_page
        # Link to the next page
        meta[:href_previous_page] = previous_page if previous_page
        # Link to the previous page
        meta[:href_next_page] = next_page if next_page
        meta
      end
    end
  end
end
