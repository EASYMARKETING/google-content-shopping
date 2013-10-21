module Google
  module Content
    module Shopping

      class ListClientAccounts < ClientAccountWrapper
        def initialize(auth_info, parent_account)
          super(auth_info, parent_account)
        end

        def perform(options = {})
          perform_for_endpoint("/content/v1/#{parent_account_number}/managedaccounts", options)
        end

        def next_page(options = {})
          paginate(:next, options)
        end

        def previous_page(options = {})
          paginate(:previous, options)
        end

        private

        def paginate(direction, options)
          if result
            perform_for_endpoint(result.send("#{direction}_page_endpoint"), options)
          else
            ClientAccounts.new
          end
        end

        def perform_for_endpoint(endpoint, options = {})
          payload = options.merge(standard_header)
          response = self.class.get(endpoint, payload)
          parse_response(response)
        end

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