require "google/content/shopping/version"

require 'forwardable'

# gems
require 'nokogiri'
require 'httparty'
require 'multi_xml'

require "google/content/shopping/client_account"
require "google/content/shopping/client_accounts"

require "google/content/shopping/client_account_wrapper"
require "google/content/shopping/client_account_wrapper/create_client_account"
require "google/content/shopping/client_account_wrapper/delete_client_account"
require "google/content/shopping/client_account_wrapper/list_client_accounts"
require "google/content/shopping/client_account_wrapper/retrieve_single_client_account"
require "google/content/shopping/client_account_wrapper/update_client_account"

require "google/content/shopping/data_feed"


module Google
  module Content
    module Shopping
    end
  end
end
