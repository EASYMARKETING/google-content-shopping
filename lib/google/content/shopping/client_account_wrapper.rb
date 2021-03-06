module Google
  module Content
    module Shopping

      class ClientAccountWrapper < GoogleContentApiWrapper

        def initialize(auth_info, parent_account_number, client_account_number = nil)
          super(auth_info)
          @parent_account_number = parent_account_number
          @client_account_number = client_account_number
        end

        attr_reader :parent_account_number, :client_account_number

        private

        def parse_response(response)
          if response.code == 200 || response.code == 201
            @result = ClientAccount.from_json(response)
            @result || response
          else
            response
          end
        end
      end

    end
  end
end
