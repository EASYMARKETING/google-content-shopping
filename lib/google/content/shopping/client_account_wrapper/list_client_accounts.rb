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

          # TODO parse into Array of ClientAccounts
          @result = parse_response(response)
          @result
        end

        def next_page
          if result
            # result.
          else
            perform
          end
        end
      end

    end
  end
end