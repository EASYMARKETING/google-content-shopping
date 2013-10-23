require "google/content/shopping/version"

require 'forwardable'

# gems
require 'nokogiri'
require 'httparty'
require 'multi_xml'

require "google/content/shopping/google_content_api_wrapper"

require "google/content/shopping/client_account"
require "google/content/shopping/client_accounts"

require "google/content/shopping/client_account_wrapper"
require "google/content/shopping/client_account_wrapper/create_client_account"
require "google/content/shopping/client_account_wrapper/delete_client_account"
require "google/content/shopping/client_account_wrapper/list_client_accounts"
require "google/content/shopping/client_account_wrapper/retrieve_single_client_account"
require "google/content/shopping/client_account_wrapper/update_client_account"

require "google/content/shopping/datafeed"
require 'google/content/shopping/datafeed_from_xml'
require "google/content/shopping/datafeeds"

require "google/content/shopping/datafeed_wrapper"
require "google/content/shopping/datafeed_wrapper/delete_datafeed_from_client_account"
require "google/content/shopping/datafeed_wrapper/list_datafeeds_for_client_account"
require "google/content/shopping/datafeed_wrapper/register_datafeed_for_client_account"
require "google/content/shopping/datafeed_wrapper/retrieve_information_for_single_datafeed"
require "google/content/shopping/datafeed_wrapper/update_information_about_single_datafeed"


module Google
  module Content
    module Shopping
    end
  end
end

class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.empty? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
