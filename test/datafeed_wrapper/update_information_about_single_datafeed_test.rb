require 'test_helper'

describe Google::Content::Shopping::UpdateInformationAboutSingleDatafeed do
  describe "#update" do
    it "should return a 200" do
      xml_request = File.open(File.expand_path('../../fixtures/datafeed_wrapper/update_information_about_single_datafeed_request.xml', __FILE__), 'r').read
      xml_response = File.open(File.expand_path('../../fixtures/datafeed_wrapper/update_information_about_single_datafeed_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 200)

      params = {
        title:              'ABC Store Electronics products feed',
        attribute_language: "en",
        content_language:   'en',
        feed_file_name:     'electronics.txt',
        fetch_schedule:     {
          :weekday => "Monday",
          :hour => {
            :number=> "12",
            :timezone => "Europe/London"
          },
          :fetch_url => "ftp://ftp.abc.com/electronics.txt"
        },
        :file_format => {
          :delimiter => "pipe",
          :encoding => "Latin1",
          :use_quoted_fields => "no",
          :format => "dsv"
        },
        target_country: 'GB'
      }

      g = Google::Content::Shopping::UpdateInformationAboutSingleDatafeed.new(auth_info_object_for_testing, "12345", "54321")
      response = g.perform(Google::Content::Shopping::Datafeed.new(params))
      MultiXml.parse(g.request_body, symbolize_keys: true).must_equal MultiXml.parse(xml_request, symbolize_keys: true)

      assert g.result.valid?

      MultiXml.parse(g.response_body, symbolize_keys: true).must_equal MultiXml.parse(xml_response, symbolize_keys: true)
    end
  end
end