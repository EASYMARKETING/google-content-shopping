require 'test_helper'

describe Google::Content::Shopping::DeleteDatafeedFromClientAccount do
  describe "#perform" do
    it "should return a 200" do
      stub_request(:any, /.*content.googleapis.com*/).to_return(
                   :status => 200)

      g = Google::Content::Shopping::DeleteDatafeedFromClientAccount.new("foobar", "12345", "54321")

      assert g.perform
    end
  end
end