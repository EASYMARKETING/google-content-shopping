require 'test_helper'

describe Google::Content::Shopping::RegisterDatafeedForClientAccount do
  describe "#create" do
    it "should return a 201" do
      xml_request = File.open(File.expand_path('../../fixtures/datafeed_wrapper/register_datafeed_for_client_account_request.xml', __FILE__), 'r').read
      xml_response = File.open(File.expand_path('../../fixtures/datafeed_wrapper/register_datafeed_for_client_account_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 201)

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
          :encoding => "utf8",
          :use_quoted_fields => "no",
          :format => "dsv"
        },
        target_country: 'GB'
      }

      g = Google::Content::Shopping::RegisterDatafeedForClientAccount.new("foobar", "12345")
      response = g.perform(Google::Content::Shopping::Datafeed.new(params))
      MultiXml.parse(g.request_body, symbolize_keys: true).must_equal MultiXml.parse(xml_request, symbolize_keys: true)

      refute g.response_body.empty?
      MultiXml.parse(g.response_body, symbolize_keys: true).must_equal MultiXml.parse(xml_response, symbolize_keys: true)

      assert g.result.valid?
    end
  end
end