module Google
  module Content
    module Shopping

      class DatafeedWrapper < GoogleContentApiWrapper

        def initialize(auth_info, client_account_number, datafeed_id = nil)
          super(auth_info)
          @client_account_number = client_account_number
          @datafeed_id           = datafeed_id
        end
        attr_reader :client_account_number, :datafeed_id

        private

        def parse_response(response)
          if response.code == 200 || response.code == 201
            @result = Datafeed.from_json(response)
            @result
          else
            response
          end
        end
      end

    end
  end
end
