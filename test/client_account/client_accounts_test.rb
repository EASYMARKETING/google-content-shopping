require 'test_helper'

describe Google::Content::Shopping::ClientAccounts do
  describe 'self#from_xml' do
    it 'should parse an xml string into a ClientAccounts object' do
      xml_from_api_doc = File.open(File.expand_path('../../fixtures/client_account/client_accounts_from_google.xml', __FILE__), 'r').read

      params = {
        id:             '78901',
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

      expected_client_accounts = Google::Content::Shopping::ClientAccounts.new
      expected_client_account1 = Google::Content::Shopping::ClientAccount.new params
      expected_client_accounts << expected_client_account1
      params2 = params.dup
      params2[:title] = 'ABCD Store'
      params2[:id] = '78901'
      expected_client_account2 = Google::Content::Shopping::ClientAccount.new params2
      expected_client_accounts << expected_client_account2

      client_accounts = Google::Content::Shopping::ClientAccounts.from_xml xml_from_api_doc

      client_accounts.must_equal expected_client_accounts
    end
  end
end