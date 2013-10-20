require 'test_helper'

describe Google::Content::Shopping::ListClientAccounts do
  describe "#perform" do
    it "should return a Category object" do
      xml_response = File.open(File.expand_path('../../fixtures/client_account_wrapper/list_client_accounts_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 200)

      g = Google::Content::Shopping::ListClientAccounts.new("foobar", "123456")
      response = g.perform

      refute response.empty?
      response.must_equal MultiXml.parse(xml_response, symbolize_keys: true)
    end
  end
end