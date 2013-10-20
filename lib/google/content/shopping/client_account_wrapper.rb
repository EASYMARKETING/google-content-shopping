module Google
  module Content
    module Shopping

      class ClientAccountWrapper
        include HTTParty
        base_uri 'content.googleapis.com'

        def initialize(auth_info, parent_account, client_account = nil)
          @auth_info      = auth_info
          @parent_account = parent_account
          @client_account = client_account

          @request_body   = ""
          @result         = nil
        end
        attr_reader :auth_info, :parent_account, :client_account, :request_body,
                    :result

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