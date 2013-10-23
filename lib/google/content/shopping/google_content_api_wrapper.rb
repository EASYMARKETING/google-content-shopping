module Google
  module Content
    module Shopping

      class GoogleContentApiWrapper
        include HTTParty
        base_uri 'content.googleapis.com'

        def initialize(auth_info)
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
            'Authorization' => "GoogleLogin auth=#{@auth_info}"
          }
        end
      end

    end
  end
end