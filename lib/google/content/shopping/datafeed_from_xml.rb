module Google
  module Content
    module Shopping

      class DatafeedFromXml < Datafeed
        def initialize(xml)
          if xml.is_a?(String)
            parsed_xml = MultiXml.parse(xml, symbolize_keys: true)
          else
            parsed_xml = xml
          end

          parsed_xml_to_attributes parsed_xml
        end

        def id=(new_id)
          begin
            super(new_id.split('/').last)
          rescue
          end
        end

        def attribute_language=(new_attribute_language)
          begin
            super(new_attribute_language.strip.downcase.to_sym)
          rescue
          end
        end

        def channel=(new_channel)
          super(new_channel.strip.downcase.to_sym)
        end

        def content_language=(new_content_language)
          begin
            super(new_content_language.strip.downcase.to_sym)
          rescue
          end
        end

        def feed_destination=(new_feed_destination)
          begin
            if new_feed_destination.is_a? Array
              super(new_feed_destination.map do |elem|
                {destination: elem[:dest], enabled: elem[:enabled].to_bool }
              end)
            else
              super({destination: new_feed_destination[:destination], enabled: new_feed_destination[:enabled].to_bool })
            end
          rescue
          end
        end

        # Input:
        # {
        #   :weekday => "Monday",
        #   :hour => {:__content__=>"12", :timezone=>"Europe/London"},
        #   :fetch_url => "ftp://ftp.abc.com/electronics.txt"
        # }
        def fetch_schedule=(new_fetch_schedule)
          begin
            result = new_fetch_schedule.dup
            result[:hour][:number] = new_fetch_schedule[:hour][:__content__]
            result[:hour].delete(:__content__)

            if new_fetch_schedule[:fetch_url].is_a? String
              result[:fetch_url] = {}
              result[:fetch_url][:url] = new_fetch_schedule[:fetch_url]
            else
              result[:fetch_url][:url] = new_fetch_schedule[:fetch_url][:__content__]
              result[:fetch_url].delete(:__content__)
            end

            super(result)
          rescue
          end
        end

        def target_country=(new_target_country)
          begin
            super(new_target_country.strip.upcase)
          rescue
          end
        end

        def link=(new_link)
          begin
            super.edit_link(new_link.select do |e|
              e.is_a?(Hash) && e[:rel].strip.downcase.to_sym == :edit
            end.first[:href])
          rescue
          end
        end

        private

        def parsed_xml_to_attributes(xml)
          if xml.has_key? :entry
            entry = xml[:entry]
          else
            entry = xml
          end

          entry.each do |key, value|
            send("#{key}=".to_sym, value)
          end
        end
      end

    end
  end
end