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

      g.result.length.must_equal  1

      MultiXml.parse(g.response_body, symbolize_keys: true).must_equal MultiXml.parse(xml_response, symbolize_keys: true)
    end
  end

  describe 'pagination' do
    it "should paginate forwards and backwards" do
      xml_response = File.open(File.expand_path('../../fixtures/client_account_wrapper/list_client_accounts_with_pagination_first_page_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 200)

      g = Google::Content::Shopping::ListClientAccounts.new("foobar", "123456")
      initial_response = g.perform
      g.result.length.must_equal 2

      xml_response = File.open(File.expand_path('../../fixtures/client_account_wrapper/list_client_accounts_with_pagination_second_page_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 200)

      g.next_page
      g.result.length.must_equal 1

      xml_response = File.open(File.expand_path('../../fixtures/client_account_wrapper/list_client_accounts_with_pagination_first_page_response.xml', __FILE__), 'r').read
      stub_request(:any, /.*content.googleapis.com*/).to_return(
        :body => xml_response,
        :status => 200)

      g.previous_page.must_equal initial_response
    end
  end
end