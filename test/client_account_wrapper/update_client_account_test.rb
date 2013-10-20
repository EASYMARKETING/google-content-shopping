require 'test_helper'

describe Google::Content::Shopping::CreateClientAccount do
  describe "#update" do
    it "should return a Category object" do
      xml_request = File.open(File.expand_path('../../fixtures/client_account_wrapper/update_client_account_request.xml', __FILE__), 'r').read
      xml_response = File.open(File.expand_path('../../fixtures/client_account_wrapper/update_client_account_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 200)

      request_options = {
        content: "Description of ABCD Store",
        internal_id: '437',
        link: "http://abcdstore.example.com",
        reviews_url: 'http://my.site.com/reviews?mo=user-rating&user=437',
        adwords_accounts: [
          {status: 'active', number: "123-456-7890"},
          {status: 'inactive', number: "234-567-8901"}
        ]
      }

      g = Google::Content::Shopping::UpdateClientAccount.new("foobar", "12345", "54321")
      response = g.perform('ABCD Store', 'no', request_options)
      MultiXml.parse(g.request_body, symbolize_keys: true).must_equal MultiXml.parse(xml_request, symbolize_keys: true)

      refute response.empty?
      response.must_equal MultiXml.parse(xml_response, symbolize_keys: true)
    end
  end
end