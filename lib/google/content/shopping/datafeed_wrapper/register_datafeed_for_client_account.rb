module Google
  module Content
    module Shopping

      class RegisterDatafeedForClientAccount < DatafeedWrapper
        def perform(datafeed, options = {})
          @request_body = datafeed.to_xml

          payload = options.merge({body: request_body})
                           .merge(standard_header)

          response = self.class.post("/content/v2/#{client_account_number}/datafeeds",
                                     payload)

          parse_response(response)
        end
      end

    end
  end
end
