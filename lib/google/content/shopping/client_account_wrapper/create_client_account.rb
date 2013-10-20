module Google
  module Content
    module Shopping

      class CreateClientAccount < ClientAccountWrapper
        def perform(title, adult_content, options = {})
          @request_body = client_account_xml(title, adult_content, options).to_xml

          payload = options.merge({body: request_body})
                           .merge(standard_header)

          response = self.class.post("/content/v1/#{parent_account}/managedaccounts",
                                     payload)

          parse_response(response)
        end
      end

    end
  end
end