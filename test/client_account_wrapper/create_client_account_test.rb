require 'test_helper'

describe Google::Content::Shopping::CreateClientAccount do
  describe "#create" do
    it "should return a Category object" do
      xml_request = File.open(File.expand_path('../../fixtures/client_account_wrapper/create_client_account.xml', __FILE__), 'r').read
      xml_response = File.open(File.expand_path('../../fixtures/client_account_wrapper/create_client_account_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 201)

      client_params = {
        title: 'ABC Store',
        content: "Description of ABC Store",
        alternate_link: "http://abcstore.example.com",
        adult_content: :no,
        internal_id: 'af437',
        reviews_url: "http://my.site.com/reviews?mo=user-rating&user=af437",
        adwords_accounts: [
          {status: 'active', number: "123-456-7890"},
          {status: 'inactive', number: "234-567-8901"}
        ]
      }

      g = Google::Content::Shopping::CreateClientAccount.new(auth_info_object_for_testing, "12345", "54321")
      response = g.perform(Google::Content::Shopping::ClientAccount.new(client_params))
      MultiXml.parse(g.request_body, symbolize_keys: true).must_equal MultiXml.parse(xml_request, symbolize_keys: true)

      refute g.response_body.empty?
      MultiXml.parse(g.response_body, symbolize_keys: true).must_equal MultiXml.parse(xml_response, symbolize_keys: true)

      assert g.result.valid?
    end
  end
end