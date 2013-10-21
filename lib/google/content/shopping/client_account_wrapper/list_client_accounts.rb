module Google
  module Content
    module Shopping

      class ListClientAccounts < ClientAccountWrapper
        def initialize(auth_info, parent_account)
          super(auth_info, parent_account)
        end

        def perform(options = {})
          payload = options.merge(standard_header)

          response = self.class.get("/content/v1/#{parent_account_number}/managedaccounts",
                                     payload)

          parse_response(response)
        end

        def next_page
          if result
            # result.
          else
            perform
          end
        end

        private

        def parse_response(response)
          if response.code == 200
            @response_body = response.body
            @result = ClientAccounts.from_xml(response)
            @result
          else
            response
          end
        end
      end

    end
  end
end