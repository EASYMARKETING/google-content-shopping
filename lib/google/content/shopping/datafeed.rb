module Google
  module Content
    module Shopping

      class Datafeed
        ATTRIBUTES = [
          :id,
          :title,
          :attribute_language,
          :channel,
          :content_language,
          :feed_destination,
          :feed_file_name,
          :fetch_schedule,
          :file_format,
          :target_country,

          :edit_link,
          :published,
          :updated,
          :edited,
          :processing_status,
          :feed_type
        ]

        attr_accessor *ATTRIBUTES

        REQUIRED_ATTRIBUTES = [
          :title,
          :attribute_language,
          :content_language,
          :feed_file_name,
          :file_format,
          :target_country
        ]

        def initialize(attributes)
          attributes.each {|k,v| send("#{k}=", v) }
        end

        def valid?
          REQUIRED_ATTRIBUTES.all? {|r| !send(r).nil? }
        end

        def feed_destination
          @feed_destination || []
        end

        def to_xml
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.entry('xmlns' => 'http://www.w3.org/2005/Atom',
              'xmlns:sc' => 'http://schemas.google.com/structuredcontent/2009') do
              xml.title(type: 'text') do
                xml.text title
              end

              xml[:sc].attribute_language do
                xml.text attribute_language
              end

              xml[:sc].channel do
                xml.text channel
              end if channel

              xml[:sc].content_language do
                xml.text content_language
              end

              feed_destination.each do |dest|
                xml[:sc].feed_destination(dest: dest[:destination], enabled: dest[:enabled])
              end

              xml[:sc].feed_file_name do
                xml.text feed_file_name
              end

              xml[:sc].fetch_schedule do
                xml[:sc].weekday do
                  xml.text fetch_schedule[:weekday]
                end
                xml[:sc].hour(timezone: fetch_schedule[:hour][:timezone]) do
                  xml.text fetch_schedule[:hour][:number]
                end
                xml[:sc].fetch_url do
                  xml.text fetch_schedule[:fetch_url]
                end
              end if fetch_schedule

              xml[:sc].file_format(format: file_format[:format]) do
                xml[:sc].delimiter file_format[:delimiter] if file_format[:delimiter]
                xml[:sc].encoding  file_format[:encoding] if file_format[:encoding]
                xml[:sc].use_quoted_fields file_format[:use_quoted_fields] if file_format[:use_quoted_fields]
              end

              xml[:sc].target_country do
                xml.text target_country
              end
            end
          end
          builder.to_xml
        end

        def self.from_xml(xml)
          data_feed_from_xml = DatafeedFromXml.new(xml)
          data_feed_from_xml.valid? ? new(data_feed_from_xml.to_h) : false
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
          @id = new_id if new_id.is_a?(String)
        end

        def title=(new_title)
          @title = new_title if new_title.is_a?(String)
        end

        # Expects a Symbol
        def attribute_language=(new_attribute_language)
          set_attribute_as_symbol(:attribute_language, new_attribute_language)
        end

        # Expects a Symbol: :online | :local
        def channel=(new_channel)
          if [:online, :local].include?(new_channel)
            @channel = new_channel
          end
        end

        # Expects a Symbol
        def content_language=(new_content_language)
          set_attribute_as_symbol(:content_language, new_content_language)
        end

        # Expects a Hash or Array of Hash like:
        # {
        #   destination: 'ProductSearch',
        #   enabled: true
        # } or
        # [
        #   {destination: 'ProductSearch',  enabled: true},
        #   {destination: 'CommerceSearch',  enabled: false}
        # ]
        def feed_destination=(new_feed_destination)
          begin
            if new_feed_destination.is_a? Hash
              keys = new_feed_destination.keys
              return unless keys.size == 2 && keys.include?(:destination) && keys.include?(:enabled)
              return unless new_feed_destination[:destination].is_a? String
              return unless new_feed_destination[:enabled].is_a?(TrueClass) || new_feed_destination[:enabled].is_a?(FalseClass)

              @feed_destination = [new_feed_destination.clone]
            elsif new_feed_destination.is_a? Array
              return unless new_feed_destination.all? do |elem|
                keys = elem.keys
                (keys.size == 2 && keys.include?(:destination) && keys.include?(:enabled)) &&
                elem[:destination].is_a?(String) &&
                (elem[:enabled].is_a?(TrueClass) || elem[:enabled].is_a?(FalseClass))
              end
              @feed_destination = new_feed_destination
            end
          rescue
          end
        end

        # Expects a String
        def feed_file_name=(new_feed_file_name)
          @feed_file_name = new_feed_file_name if new_feed_file_name.is_a?(String)
        end

        # Expects Hash like:
        # {
        #   :weekday=>"Monday",
        #   :hour=> {
        #     :number =>"12",
        #     :timezone=>"Europe/London"
        #   },
        #   :fetch_url => "ftp://ftp.abc.com/electronics.txt"
        # }
        def fetch_schedule=(new_fetch_schedule)
          begin
            keys = new_fetch_schedule.keys

            return unless keys.include?(:fetch_url) ||
              (keys.size == 3 && keys.include?(:day_of_month) && keys.include?(:hour)) ||
              (keys.size == 3 && keys.include?(:weekday) && keys.include?(:hour)) ||
              (keys.size == 2 && keys.include?(:hour))

            @fetch_schedule = new_fetch_schedule.clone
          rescue
          end
        end

        # Expects a Hash like:
        # {
        #   :delimeter         => nil,
        #   :encoding          => "utf8",
        #   :use_quoted_fields => "no",
        #   :format            => "dsv"
        # } or
        # {
        #   :encoding          => "utf8",
        #   :format            => "xml"
        # } or
        # {
        #   :format            => "auto"
        # }
        def file_format=(new_file_format)
          begin
            format = new_file_format[:format].strip.downcase.to_sym
            if format == :dsv
              return unless new_file_format.has_key?(:delimiter)
              delimiter = new_file_format[:delimiter].to_sym
              return unless delimiter == :tab || delimiter == :pipe || delimiter == :tilde

              return unless new_file_format.has_key?(:use_quoted_fields)
              use_quoted_fields = new_file_format[:use_quoted_fields].to_sym
              return unless use_quoted_fields == :yes || use_quoted_fields == :no
            end

            @file_format = new_file_format
          rescue
          end
        end

        # Expects a String
        def target_country=(new_target_country)
          @target_country = new_target_country if new_target_country.is_a?(String)
        end

        # Expects a String
        def edit_link=(new_edit_link)
          @edit_link = new_edit_link if new_edit_link.is_a?(String)
        end

        # Expects a String
        def published=(new_published)
          @published = new_published if new_published.is_a?(String)
        end

        # Expects a String
        def updated=(new_updated)
          @updated = new_updated if new_updated.is_a?(String)
        end

        # Expects a String
        def edited=(new_edited)
          @edited = new_edited if new_edited.is_a?(String)
        end

        # Expects a Symbol
        def processing_status=(new_processing_status)
          @processing_status = new_processing_status if new_processing_status.is_a?(Symbol)
        end

        def feed_type=(new_feed_type)
          @feed_type = new_feed_type if new_feed_type.is_a?(String)
        end

        private

        def set_attribute_as_symbol(attribute, value)
          begin
            if value.is_a? String
              instance_variable_set("@#{attribute}", value.strip.downcase.to_sym)
            elsif value.is_a? Symbol
              instance_variable_set("@#{attribute}", value.to_s.strip.downcase.to_sym)
            end
          rescue
          end
        end
      end

    end
  end
end