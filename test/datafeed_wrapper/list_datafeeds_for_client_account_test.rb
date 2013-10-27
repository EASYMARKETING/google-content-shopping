require 'test_helper'

describe Google::Content::Shopping::ListDatafeedsForClientAccount do
  describe "#perform" do
    it "should return a 200" do
      xml_response = File.open(File.expand_path('../../fixtures/datafeed_wrapper/list_datafeeds_for_client_account_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 200)

      g = Google::Content::Shopping::ListDatafeedsForClientAccount.new(auth_info_object_for_testing, "123456")
      response = g.perform

      g.result.length.must_equal  1

      MultiXml.parse(g.response_body, symbolize_keys: true).must_equal MultiXml.parse(xml_response, symbolize_keys: true)
    end
  end
end