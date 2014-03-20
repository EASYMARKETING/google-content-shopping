module Google
  module Content
    module Shopping

      class RetrieveDataQuality < ClientAccountWrapper
        def perform
          response = self.class.get("/content/v1/#{parent_account_number}/dataquality/#{client_account_number}",
                                     standard_header)

          parse_response(response)
        end
      end

    end
  end
end
