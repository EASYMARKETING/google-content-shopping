module Google
  module Content
    module Shopping

      class ClientAccounts
        include Enumerable
        extend  Forwardable
        def_delegators :@accounts, :length, :size, :each

        def initialize(new_accounts = [])
          @accounts = new_accounts
          @next_page_endpoint = ''
          @previous_page_endpoint = ''
        end
        attr_reader :next_page_endpoint, :previous_page_endpoint

        def <<(account)
          account.is_a?(ClientAccount) ? @accounts << account : false
        end

        def ==(other)
          other.is_a?(self.class) && other.length == length &&
            all? {|elem| other.include? elem }
        end

        def link=(new_link)
          extract_pagination_link_from_xml(:next, new_link)
          extract_pagination_link_from_xml(:previous, new_link)
        end

        def self.from_xml(xml_string)
          parsed_xml = MultiXml.parse(xml_string, symbolize_keys: true)

          new_accounts = ClientAccounts.new
          entries = parsed_xml[:feed][:entry]

          if entries.is_a?(Array)
            begin
              entries.each do |entry|
                new_accounts << ClientAccount.from_xml(entry)
              end
            rescue
            end
          elsif entries.is_a?(Hash)
            begin
              new_accounts << ClientAccount.from_xml(entries)
            rescue
            end
          end

          new_accounts
        end

        private

        def extract_pagination_link_from_xml(link_type, link_xml)
          endpoint = extract_link_from_xml(link_type, link_xml).split('googleapis.com').last
          self.instance_variable_set("@#{link_type}_page_endpoint".to_sym, url) if endpoint
        end

        def extract_link_from_xml(link_type, link_xml)
          begin
            new_link.select do |e|
              e.is_a?(Hash) && e[:rel].strip.downcase.to_sym == link_type
            end.first[:href]
          rescue
            ''
          end
        end
      end

    end
  end
end