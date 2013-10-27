require 'test_helper'

describe Google::Content::Shopping::UpdateClientAccount do
  describe "#update" do
    it "should return a Category object" do
      xml_request = File.open(File.expand_path('../../fixtures/client_account_wrapper/update_client_account_request.xml', __FILE__), 'r').read
      xml_response = File.open(File.expand_path('../../fixtures/client_account_wrapper/update_client_account_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 200)

      client_params = {
        title: 'ABCD Store',
        content: "Description of ABCD Store",
        alternate_link: "http://abcdstore.example.com",
        adult_content: :no,
        internal_id: '437',
        reviews_url: "http://my.site.com/reviews?mo=user-rating&user=437",
        adwords_accounts: [
          {status: 'active', number: "123-456-7890"},
          {status: 'inactive', number: "234-567-8901"}
        ]
      }

      g = Google::Content::Shopping::UpdateClientAccount.new(auth_info_object_for_testing, "12345", "54321")
      response = g.perform(Google::Content::Shopping::ClientAccount.new(client_params))
      MultiXml.parse(g.request_body, symbolize_keys: true).must_equal MultiXml.parse(xml_request, symbolize_keys: true)

      assert g.result.valid?

      MultiXml.parse(g.response_body, symbolize_keys: true).must_equal MultiXml.parse(xml_response, symbolize_keys: true)
    end
  end
end