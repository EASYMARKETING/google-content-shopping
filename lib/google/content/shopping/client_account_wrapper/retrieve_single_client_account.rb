module Google
  module Content
    module Shopping

      class RetrieveSingleClientAccount < ClientAccountWrapper
        def perform
          response = self.class.get("/content/v1/#{parent_account_number}/managedaccounts/#{client_account_number}",
                                     standard_header)

          parse_response(response)
        end
      end

    end
  end
end