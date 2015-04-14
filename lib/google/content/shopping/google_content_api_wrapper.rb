module Google
  module Content
    module Shopping

      class GoogleContentApiWrapper
        include HTTParty
        base_uri 'https://www.googleapis.com'

        def initialize(auth_info)
          unless auth_info.respond_to?(:access_token_header) && auth_info.access_token_header.is_a?(String)
            raise ArgumentError, 'The auth_info object must respond to the access_token_header method'
          end

          @auth_info             = auth_info

          @request_body          = ""
          @response_body         = ""
          @result                = nil
        end
        attr_reader :auth_info, :request_body, :result, :response_body

        private

        def standard_header
          {
            headers: {
              'Content-Type'  => 'application/xml',
              'Authorization' => auth_info.access_token_header
            }
          }
        end
      end

    end
  end
end
