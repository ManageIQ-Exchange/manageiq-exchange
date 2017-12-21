module V1
  ##
  # User controller
  # Provides information about the user
  ##
  class ApplicationController < ActionController::API

    def return_response(*args)
      byebug
      args.first[:expand] = expand_resources?
      args.first[:json] = apply_filter(args.first[:json]) if filter?
      args.first[:metadata] = {}
      render *args
    end

    def expand_resources?
      params["expand"] == "resources"
    end

    def query_options
      filter if params[:filter]
    end

    def filter?
      params.include? "filter"
    end

    def apply_filter(records)
      columns_to_filter = seed_data[controller_name]['filter']
      query = ""
      params[:filter].each do |filter|
        next unless columns_to_filter.include? filter.downcase
        query += " and " unless query.empty?
        query += "#{filter.downcase} like?"
      end
      @result.where(query)
    end

    def seed_file_name
      @seed_file_name ||= Rails.root.join('product', 'query_options.yml')
    end

    def seed_data
      @seed_data ||= File.exist?(seed_file_name) ? YAML.load_file(seed_file_name) : []
    end

  end
end
