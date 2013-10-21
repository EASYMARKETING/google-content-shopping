module Google
  module Content
    module Shopping

      class ClientAccountWrapper
        include HTTParty
        base_uri 'content.googleapis.com'

        def initialize(auth_info, parent_account_number, client_account_number = nil)
          @auth_info             = auth_info
          @parent_account_number = parent_account_number
          @client_account_number = client_account_number

          @request_body          = ""
          @result                = nil
        end
        attr_reader :auth_info, :parent_account_number, :client_account_number,
         :request_body, :result

        private

        def standard_header
          {
            'Content-Type'  => 'application/atom+xml',
            'Authorization' => "GoogleLogin auth=#{@auth_info}"
          }
        end

        def parse_response(response)
          if response.code == 200 || response.code == 201
            MultiXml.parse(response.body, symbolize_keys: true)
          else
            response
          end
        end
      end

    end
  end
end