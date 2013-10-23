module Google
  module Content
    module Shopping

      class DeleteDatafeedFromClientAccount < DatafeedWrapper
        def perform
          response = self.class.delete("/content/v1/#{client_account_number}/datafeeds/products/#{datafeed_id}",
                                       standard_header)

          response.code == 200
        end
      end

    end
  end
end