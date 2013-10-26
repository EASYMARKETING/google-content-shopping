module Google
  module Content
    module Shopping

      class Datafeeds
        include Enumerable
        extend  Forwardable
        def_delegators :@feeds, :length, :size, :each

        def initialize(new_feeds = [])
          @feeds = new_feeds
        end

        def <<(feed)
          feed.is_a?(Datafeed) ? @feeds << feed : false
        end

        def ==(other)
          other.is_a?(self.class) && other.length == length &&
            all? {|elem| other.include? elem }
        end

        def self.from_xml(xml)
          parsed_xml = MultiXml.parse(xml, symbolize_keys: true)

          new_feeds = Datafeeds.new
          entries = parsed_xml[:feed][:entry]

          if entries.is_a?(Array)
            begin
              entries.each do |entry|
                new_feeds << Datafeed.from_xml(entry)
              end
            rescue
            end
          elsif entries.is_a?(Hash)
            begin
              new_feeds << Datafeed.from_xml(entries)
            rescue
            end
          end

          new_feeds
        end
      end

    end
  end
end