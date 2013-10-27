require 'test_helper'

describe Google::Content::Shopping::RetrieveSingleClientAccount do
  describe "#perform" do
    it "should return a Category object" do
      xml_response = File.open(File.expand_path('../../fixtures/client_account_wrapper/retrieve_single_client_account_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 200)

      g = Google::Content::Shopping::RetrieveSingleClientAccount.new(auth_info_object_for_testing, "123456", "78901")
      g.perform

      MultiXml.parse(g.response_body, symbolize_keys: true).must_equal MultiXml.parse(xml_response, symbolize_keys: true)

      assert g.result.valid?
    end
  end
end