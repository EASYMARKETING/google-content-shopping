require 'google/content/shopping'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/minitest'
require 'pry'

Struct.new('TestAuth', :access_token_header)

def auth_info_object_for_testing
  Struct::TestAuth.new('Bearer foobar')
end