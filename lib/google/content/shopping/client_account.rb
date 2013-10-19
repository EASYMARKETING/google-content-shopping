module Google
  module Content
    module Shopping

      class ClientAccount
        include HTTParty
        base_uri 'content.googleapis.com'

        def initialize(auth_info, parent_account, client_account)
          @auth_info      = auth_info
          @parent_account = parent_account
          @client_account = client_account

          @request_body   = ""
        end
        attr_reader :auth_info, :parent_account, :client_account, :request_body

        def self.list
        end

        def create(title, adult_content, options = {})
          @request_body = client_account_xml(title, adult_content, options).to_xml

          payload = options.merge({body: request_body})
                           .merge(standard_header)

          response = self.class.post("/content/v1/#{parent_account}/managedaccounts",
                                     payload)

          parse_response(response)
        end

        def read
          payload = options.merge(standard_header)

          response = self.class.get("/content/v1/#{parent_account}/managedaccounts/#{client_account}",
                                     payload)

          parse_response(response)
        end

        ### TODO read multiple

        # If the 'adwords_accounts' element is not included in an update
        # request, the existing associated AdWords accounts settings will be
        # unchanged and returned with the response.
        #
        # As long as 'adwords_accounts' is included in the request, the values
        # contained are interpreted as the complete settings. For example, if
        # your account was previously associated with the active AdWords account
        # 222-333-4444 by including:
        # {
        #   adwords_accounts: [
        #     {status: :active, number: '222-333-4444'}
        #   ]
        # }
        # and you submit an update containing:
        # {
        #   adwords_accounts: [
        #     {status: :active, number: '123-456-7890'},
        #     {status: :inactive, number: '234-567-8901'}
        #   ]
        # }
        # then the association with 222-333-4444 will be removed.
        #
        # If you would like to remove all associated AdWords accounts, submit an
        # update with an empty 'adwords_accounts' element.
        def update(title, adult_content, options = {})
          @request_body = client_account_xml(title, adult_content, options).to_xml

          payload = options.merge({body: request_body})
                           .merge(standard_header)

          response = self.class.put("/content/v1/#{parent_account}/managedaccounts/#{client_account}",
                                     payload)

          parse_response(response)
        end

        # When you delete a client account, all of the items in that client's
        # feeds will be removed from the Google search index in approximately
        # one day.
        def delete
          payload = options.merge(standard_header)

          response = self.class.delete("/content/v1/#{parent_account}/managedaccounts/#{client_account}",
                                       payload)

          response.code == 200
        end

        private

        def client_account_xml(title, adult_content, attributes)
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.entry('xmlns' => 'http://www.w3.org/2005/Atom',
              'xmlns:sc' => 'http://schemas.google.com/structuredcontent/2009') do
              xml.title(type: 'text') do
                xml.text title
              end

              xml.content(type: 'text') do
                xml.text attributes[:content]
              end if attributes[:content]

              xml.link(rel: "alternate", type: 'text/html', href: attributes[:link]) if attributes[:link]

              xml[:sc].adult_content do
                xml.text adult_content
              end

              xml[:sc].internal_id do
                xml.text attributes[:internal_id]
              end if attributes[:internal_id]

              xml[:sc].reviews_url do
                xml.text attributes[:reviews_url]
              end if attributes[:reviews_url]

              xml[:sc].adwords_accounts do
                attributes[:adwords_accounts].each do |ac|
                  xml[:sc].adwords_account(status: ac[:status]) do
                    xml.text ac[:number]
                  end
                end
              end if attributes[:adwords_accounts]
            end
          end
        end

        def standard_header
          {
            'Content-Type'  => 'application/atom+xml',
            'Authorization' => "GoogleLogin auth=#{@auth_info}"
          }
        end

        def parse_response(response)
          if response.code == 200 || response.code == 201
            MultiXml.parse(response.body, symbolize_keys: true)
          else
            response
          end
        end
      end

    end
  end
end