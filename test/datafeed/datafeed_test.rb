require 'test_helper'

describe Google::Content::Shopping::Datafeed do
  describe "#to_xml" do
    it "should equal the XML in Google's API doc" do
      xml_from_api_doc = File.open(File.expand_path('../../fixtures/datafeed/datafeed.xml', __FILE__), 'r').read

      params = {
        title:              'ABC Store Electronics products feed',
        attribute_language: "en",
        content_language:   'en',
        feed_file_name:     'electronics.txt',
        fetch_schedule:     {
          :weekday => "Monday",
          :hour => {:number=> "12", :timezone => "Europe/London"},
          :fetch_url => "ftp://ftp.abc.com/electronics.txt"
          },
          :file_format => {
           :delimiter => "pipe",
           :encoding => "utf8",
           :use_quoted_fields => "no",
           :format => "dsv"
           },
           target_country: 'GB'
         }

      datafeed = Google::Content::Shopping::Datafeed.new params

      assert datafeed.valid?

      MultiXml.parse(datafeed.to_xml, symbolize_keys: true).must_equal MultiXml.parse(xml_from_api_doc, symbolize_keys: true)
    end
    it "should accept fetch username and password" do
      xml_from_api_doc = File.open(File.expand_path('../../fixtures/datafeed/datafeed_with_fetchpassword.xml', __FILE__), 'r').read

      params = {
        title:              'ABC Store Electronics products feed',
        attribute_language: "en",
        content_language:   'en',
        feed_file_name:     'electronics.txt',
        fetch_username:     'foo',
        fetch_password:     'bar',
        fetch_schedule:     {
          :weekday => "Monday",
          :hour => {:number=> "12", :timezone => "Europe/London"},
          :fetch_url => "ftp://ftp.abc.com/electronics.txt"
          },
          :file_format => {
           :delimiter => "pipe",
           :encoding => "utf8",
           :use_quoted_fields => "no",
           :format => "dsv"
           },
           target_country: 'GB'
         }

      datafeed = Google::Content::Shopping::Datafeed.new params

      assert datafeed.valid?

      MultiXml.parse(datafeed.to_xml, symbolize_keys: true).must_equal MultiXml.parse(xml_from_api_doc, symbolize_keys: true)
    end
  end

  describe 'self#from_xml' do
    it 'should parse an xml string into a Datafeed object' do
      xml_from_api_doc = File.open(File.expand_path('../../fixtures/datafeed/datafeed_from_google.xml', __FILE__), 'r').read

      params = {
        id:                 '989898',
        title:              'xyz',
        attribute_language: "en",
        content_language:   'en',
        feed_file_name:     'xyz',
        feed_type:          'listings',
        feed_destination:   [
          {:destination=>"ProductSearch", :enabled=>true},
          {:destination=>"CommerceSearch", :enabled=>false}
        ],
        :file_format => {
           :use_quoted_fields => "no",
           :format => "auto"
        },
        fetch_schedule: {
          :weekday => "Monday",
          :hour => {
            :timezone => "Europe/London",
            :number=>"12"
          },
          :fetch_url=> {url: "ftp://ftp.abc.com/electronics.txt"}
        },
        published:          '2010-12-15T15:47:37.000Z',
        edited:             '2010-12-15T15:47:37.000Z',
        updated:            '2010-12-15T15:47:37.000Z',
        target_country:     'US'
      }

      expected_datafeed = Google::Content::Shopping::Datafeed.new params

      datafeed = Google::Content::Shopping::Datafeed.from_xml xml_from_api_doc

      datafeed.must_equal expected_datafeed
    end
  end
end