module V1
  class ApiController
    ###
    # Parameters request module
    #
    ##
    module Parameters
      PARAMS = {
        "page":  'numeric?',
        "limit": 'numeric?'
      }.freeze

      # Check the params of the GLOBAL VAR **PARAMS**.
      #
      # @return [boolean] if checks are ok or not
      def check_params
        # For each key,value in GLOBAL VAR **PARAMS**.
        PARAMS.each do |param, method|
          # Next if there isn't param in the request of client
          next unless params[param]
          # Check the *param* with *method*
          unless send(method, params[param])
            @error_object = "Param #{param} is wrong, #{method} failed"
            return false
          end
        end
        true
      end

      # Check if there is a param expand=resources in request
      #
      # @return [boolean] if there is the param expand=resources
      def expand_resources?
        params['expand'] == 'resources'
      end

      # Check if the obj is a numeric value
      #
      # @return [boolean] if is numeric
      def numeric?(obj)
        obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil? ? false : true
      end

      def true?(obj)
        obj.to_s == "true"
      end
    end
  end
end
