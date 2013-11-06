module Google
  module Content
    module Shopping

      class ClientAccount
        ATTRIBUTES = [
          :id,
          :title,
          :content,
          :alternate_link,
          :adult_content,
          :internal_id,
          :reviews_url,
          :adwords_accounts,

          :account_status,
          :published,
          :updated,
          :edited
        ]

        attr_accessor *ATTRIBUTES

        REQUIRED_ATTRIBUTES = [
          :title,
          :adult_content
        ]

        def initialize(attributes)
          attributes.each {|k,v| send("#{k}=", v) }
        end

        def valid?
          REQUIRED_ATTRIBUTES.all? {|r| !send(r).nil? }
        end

        def to_xml
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.entry('xmlns' => 'http://www.w3.org/2005/Atom',
              'xmlns:sc' => 'http://schemas.google.com/structuredcontent/2009') do
              xml.title(type: 'text') do
                xml.text title
              end

              xml.content(type: 'text') do
                xml.text content
              end if content

              xml.link(rel: "alternate", type: 'text/html', href: alternate_link) if alternate_link

              xml[:sc].adult_content do
                xml.text adult_content
              end

              xml[:sc].internal_id do
                xml.text internal_id
              end if internal_id

              xml[:sc].reviews_url do
                xml.text reviews_url
              end if reviews_url

              xml[:sc].adwords_accounts do
                adwords_accounts.each do |ac|
                  xml[:sc].adwords_account(status: ac[:status]) do
                    xml.text ac[:number]
                  end
                end
              end if adwords_accounts
            end
          end
          builder.to_xml
        end

        def self.from_xml(client_account_xml)
          if client_account_xml.is_a?(String)
            parsed_xml = MultiXml.parse(client_account_xml, symbolize_keys: true)
          else
            parsed_xml = client_account_xml
          end

          client_account = new({})
          client_account.parsed_xml_to_attributes parsed_xml

          client_account.valid? ? client_account : false
        end

        def to_h
          result = {}

          ATTRIBUTES.each do |attr|
            value = send(attr)
            result[attr] = value if value
          end

          result
        end

        def ==(other)
          other.is_a?(self.class) && other.respond_to?(:to_h) &&
            other.to_h == to_h
        end

        def id=(new_id)
          begin
            parts = new_id.split('/')
            if parts.size > 1
              # if new_id coming from xml like: http://content.googleapis.com/content/account/78901
              @id = parts.last
            else
              @id = new_id
            end
          rescue
          end
        end

        def link=(new_link)
          begin
            self.alternate_link = new_link.select do |e|
              e.is_a?(Hash) && e[:rel].strip.downcase.to_sym == :alternate
            end.first[:href]
          rescue
          end
        end

        def content=(new_content)
          begin
            if new_content.is_a? Hash
              @content = new_content[:__content__]
            else
              @content = new_content
            end
          rescue
          end
        end

        def title=(new_title)
          begin
            if new_title.is_a? Hash
              @title = new_title[:__content__]
            else
              @title = new_title
            end
          rescue
          end
        end

        def adwords_accounts=(new_adwords_accounts)
          begin
            if new_adwords_accounts.is_a?(Hash)
              adwords = new_adwords_accounts[:adwords_account]
            elsif new_adwords_accounts.is_a?(Array)
              adwords = new_adwords_accounts
            end

            @adwords_accounts = adwords.map do |status|
              if status.has_key?(:number)
                {status: status[:status].to_s.strip.downcase.to_sym, number: status[:number]}
              else
                {status: status[:status].to_s.strip.downcase.to_sym, number: status[:__content__]}
              end
            end
          rescue
            @adwords_accounts = []
          end
        end

        def adult_content=(new_adult_content)
          begin
            if new_adult_content == :no || new_adult_content == :yes
               @adult_content = new_adult_content
            elsif new_adult_content.strip.downcase == 'no' ||
               new_adult_content.strip.downcase == 'yes'
               @adult_content = new_adult_content.strip.downcase.to_sym
            end
          rescue
          end
        end

        def account_status
          @account_status && @account_status.is_a?(String) ? @account_status.to_sym : nil
        end

        def parsed_xml_to_attributes(client_account_parsed_xml)
          # {
          #   :entry => {
          #    :id => "http://content.googleapis.com/content/account/78901",
          #    :published => "2010-07-15T22:26:32.967Z",
          #    :updated => "2010-07-15T22:26:38.397Z",
          #    :edited => "2010-07-23T15:04:07.370Z",
          #    :title => "ABCD Store",
          #    :content => "Description of ABCD Store",
          #    :link => [
          #     {
          #       :rel => "alternate",
          #       :type => "text/html",
          #       :href => "http://abcdstore.example.com"
          #     },
          #     {
          #       :rel => "self",
          #       :type => "application/atom+xml",
          #       :href => "https://content.googleapis.com/content/v1/123456/managedaccounts/78901"
          #     },
          #     {
          #       :rel => "edit",
          #       :type => "application/atom+xml",
          #       :href => "https://content.googleapis.com/content/v1/123456/managedaccounts/78901"
          #     }
          #    ],
          #     :account_status => "active",
          #     :adult_content => "no",
          #     :internal_id => "437",
          #     :reviews_url => "http://my.site.com/reviews?mo=user-rating&user=437",
          #     :adwords_accounts =>
          #     {
          #       :adwords_account => [
          #         {:__content__=> "123-456-7890", :status=> "active"},
          #         {:__content__=> "234-567-8901", :status=> "inactive"}
          #       ]
          #     }
          #   }
          # }

          begin
            if client_account_parsed_xml.has_key?(:entry)
              entry = client_account_parsed_xml[:entry]
            else
              entry = client_account_parsed_xml
            end

            entry.each do |key, value|
              begin
                send("#{key}=", value)
              rescue
              end
            end
          rescue
          end
        end
      end

    end
  end
end