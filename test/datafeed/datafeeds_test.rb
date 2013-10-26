require 'test_helper'

describe Google::Content::Shopping::Datafeeds do
  describe 'self#from_xml' do
    it 'should parse an xml string into a Datafeeds object' do
      xml_from_api_doc = File.open(File.expand_path('../../fixtures/datafeed/datafeeds_from_google.xml', __FILE__), 'r').read

      params = {
        id:                 '989898',
        title:              'xyz',
        attribute_language: "en",
        content_language:   'en',
        feed_file_name:     'xyz',
        feed_type:          'listings',
        fetch_schedule:     {
          :weekday => "Monday",
          :hour => {:number=> "12", :timezone => "Europe/London"},
          :fetch_url => {url: "ftp://ftp.abc.com/electronics.txt"}
          },
          :file_format => {
           :use_quoted_fields => "no",
           :format => "auto"
           },
           target_country: 'US',
           updated: '2010-12-15T15:47:37.000Z',
           published: '2010-12-15T15:47:37.000Z',
           edited: '2010-12-15T15:47:37.000Z'
         }

      expected_datafeeds = Google::Content::Shopping::Datafeeds.new
      expected_datafeed1 = Google::Content::Shopping::Datafeed.new params
      expected_datafeeds << expected_datafeed1
      params2 = params.clone

      params2[:id] = '989899'
      params2[:title] = 'xyzfoo'
      params2[:feed_file_name] = 'xyzfoo'
      params2[:fetch_schedule][:fetch_url] = {}
      params2[:fetch_schedule][:fetch_url][:url] = 'ftp://ftp.abc.com/electronicsfoo.txt'
      expected_datafeed2 = Google::Content::Shopping::Datafeed.new params2
      expected_datafeeds << expected_datafeed2

      datafeeds = Google::Content::Shopping::Datafeeds.from_xml xml_from_api_doc

      datafeeds.must_equal expected_datafeeds
    end
  end
end