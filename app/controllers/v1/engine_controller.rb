module V1
  class EngineController < ApplicationController
    def return_response(*args)
      res = args.first[:json]
      args.first[:json] = process_request(res)
      args.first[:expand] = expand_resources?
      args.first[:metadata] = {}
      render *args
    end

    def expand_resources?
      params["expand"] == "resources"
    end

    def process_request(res)
      miq_expression = filter_param
      if miq_expression
        sql, _, attrs = miq_expression.to_sql
        res = res.where(sql) if attrs[:supported_by_sql]
      end
      res
    end

    def filter_param
      return nil if params['filter'].blank?
      Filter.parse(params["filter"], controller_name.classify.constantize)
    end

    def seed_file_name
      @seed_file_name ||= Rails.root.join('product', 'query_options.yml')
    end

    def seed_data
      @seed_data ||= File.exist?(seed_file_name) ? YAML.load_file(seed_file_name) : []
    end
  end
end