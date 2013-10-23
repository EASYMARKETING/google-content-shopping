module Google
  module Content
    module Shopping

      class RetrieveInformationForSingleDatafeed < DatafeedWrapper
        def perform
          response = self.class.get("/content/v1/#{client_account_number}/datafeeds/products/#{datafeed_id}",
                                     standard_header)

          parse_response(response)
        end
      end

    end
  end
end