module Google
  module Content
    module Shopping

      class GoogleContentApiWrapper
        include HTTParty
        base_uri 'content.googleapis.com'

        def initialize(auth_info)
          unless auth_info.respond_to?(:access_token) && auth_info.access_token.is_a?(String)
            raise ArgumentError, 'The auth_info object must respond to the access_token method'
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
            'Content-Type'  => 'application/atom+xml',
            'Authorization' => "Bearer #{auth_info.access_token}"
          }
        end
      end

    end
  end
end