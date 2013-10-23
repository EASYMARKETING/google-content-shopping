module Google
  module Content
    module Shopping

      class UpdateInformationAboutSingleDatafeed < DatafeedWrapper
        def perform(datafeed, options = {})
          @request_body = datafeed.to_xml

          payload = options.merge({body: request_body})
                           .merge(standard_header)

          response = self.class.put("/content/v1/#{client_account_number}/datafeeds/products/#{datafeed_id}",
                                     payload)

          parse_response(response)
        end
      end

    end
  end
end