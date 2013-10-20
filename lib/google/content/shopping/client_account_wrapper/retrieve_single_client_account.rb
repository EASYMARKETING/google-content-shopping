module Google
  module Content
    module Shopping

      class RetrieveSingleClientAccount < ClientAccountWrapper
        def perform
          response = self.class.get("/content/v1/#{parent_account}/managedaccounts/#{client_account}",
                                     standard_header)

          parse_response(response)
        end
      end

    end
  end
end