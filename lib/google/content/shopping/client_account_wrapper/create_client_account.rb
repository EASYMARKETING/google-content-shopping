module Google
  module Content
    module Shopping

      class CreateClientAccount < ClientAccountWrapper
        def perform(client_account, options = {})
          @request_body = client_account.to_xml

          payload = options.merge({body: request_body})
                           .merge(standard_header)

          response = self.class.post("/content/v1/#{parent_account_number}/managedaccounts",
                                     payload)

          parse_response(response)
        end
      end

    end
  end
end