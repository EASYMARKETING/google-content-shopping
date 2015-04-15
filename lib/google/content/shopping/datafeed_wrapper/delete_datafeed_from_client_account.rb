module Google
  module Content
    module Shopping

      class DeleteDatafeedFromClientAccount < DatafeedWrapper
        def perform
          response = self.class.delete("/content/v2/#{client_account_number}/datafeeds/#{datafeed_id}",
                                       standard_header)

          response.code == 204
        end
      end

    end
  end
end
