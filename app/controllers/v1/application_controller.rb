module V1
  ##
  # User controller
  # Provides information about the user
  ##
  class ApplicationController < ActionController::API

    def return_response(*args)
      args.first[:expand] = expand_resources?
      render *args
    end

    def expand_resources?
      params["expand"] == "resources"
    end
  end
end
