require 'test_helper'

describe Google::Content::Shopping::ClientAccount do
  describe "#to_xml" do
    it "should equal the XML in Google's API doc" do
      xml_from_api_doc = File.open(File.expand_path('../../fixtures/client_account/client_account.xml', __FILE__), 'r').read

      params = {
        title:          'ABC Store',
        content:        "Description of ABC Store",
        alternate_link: "http://abcstore.example.com",
        adult_content:  :no,
        internal_id:    'af437',
        reviews_url:    "http://my.site.com/reviews?mo=user-rating&user=af437",
        adwords_accounts: [
          {status: :active, number: "123-456-7890"},
          {status: :inactive, number: "234-567-8901"}
        ]
      }

      client_account = Google::Content::Shopping::ClientAccount.new params

      assert client_account.valid?

      MultiXml.parse(client_account.to_xml, symbolize_keys: true).must_equal MultiXml.parse(xml_from_api_doc, symbolize_keys: true)
    end
  end

  describe 'self#from_xml' do
    it 'should parse an xml string into a ClientAccount object' do
      xml_from_api_doc = File.open(File.expand_path('../../fixtures/client_account/client_account_from_google.xml', __FILE__), 'r').read

      params = {
        id:             "78901",
        title:          'ABC Store',
        content:        "Description of ABC Store",
        alternate_link: "http://abcstore.example.com",
        adult_content:  :no,
        internal_id:    'af437',
        reviews_url:    "http://my.site.com/reviews?mo=user-rating&user=af437",
        published:      '2010-06-15T22:26:32.967Z',
        edited:         "2010-07-23T14:36:24.315Z",
        updated:        '2010-07-15T22:26:38.397Z',
        account_status: 'active',
        adwords_accounts: [
          {status: :active, number: "123-456-7890"},
          {status: :inactive, number: "234-567-8901"}
        ]
      }

      expected_client_account = Google::Content::Shopping::ClientAccount.new params

      client_account = Google::Content::Shopping::ClientAccount.from_xml xml_from_api_doc

      client_account.must_equal expected_client_account
    end
  end
end