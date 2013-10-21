module Google
  module Content
    module Shopping

      class ClientAccounts
        include Enumerable
        extend  Forwardable
        def_delegators :@accounts, :length, :each

        def initialize(new_accounts = [])
          @accounts = new_accounts
        end

        def <<(account)
          account.is_a?(ClientAccount) ? @accounts << account : false
        end

        def ==(other)
          other.is_a?(self.class) && other.length == length &&
            all? {|elem| other.include? elem }
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
      end

    end
  end
end