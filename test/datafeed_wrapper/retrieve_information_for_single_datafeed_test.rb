require 'test_helper'

describe Google::Content::Shopping::RetrieveInformationForSingleDatafeed do
  describe "#perform" do
    it "it should return a 200" do
      xml_response = File.open(File.expand_path('../../fixtures/datafeed_wrapper/retrieve_information_for_single_datafeed_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 200)

      g = Google::Content::Shopping::RetrieveInformationForSingleDatafeed.new("foobar", "123456", "78901")
      g.perform

      MultiXml.parse(g.response_body, symbolize_keys: true).must_equal MultiXml.parse(xml_response, symbolize_keys: true)

      assert g.result.valid?
    end
  end
end