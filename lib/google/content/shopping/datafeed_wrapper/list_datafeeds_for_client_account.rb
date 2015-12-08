module Google
  module Content
    module Shopping

      class ListDatafeedsForClientAccount < DatafeedWrapper
        def perform(options = {})
          perform_for_endpoint("/content/v2/#{client_account_number}/datafeeds", options)
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
            Datafeeds.new
          end
        end

        def perform_for_endpoint(endpoint, options = {})
          payload = options.merge(standard_header)
          response = self.class.get(endpoint, payload)
          parse_response(response)
        end

        def parse_response(response)
          if response.code == 200
            #@response_body = response.body
            #@result = Datafeeds.from_xml(response.body)
            #@result

            @result = JSON.parse(response.body)["resources"]
          else
            response
          end
        end
      end

    end
  end
end
