module Google
  module Content
    module Shopping

      class Auth
        def initialize(private_key_location, email_address)
          @private_key_location = private_key_location
          @email_address        = email_address

          @key = Google::APIClient::PKCS12.load_key(@private_key_location, 'notasecret')
          @service_account = Google::APIClient::JWTAsserter.new(
            # Example email_address:
            # '123456-abcdef@developer.gserviceaccount.com',
            @email_address,
            'https://www.googleapis.com/auth/structuredcontent',
            @key
          )
        end

        def access_token
          if @authorization && !@authorization.expired?
            @authorization.access_token
          else
            @authorization = @service_account.authorize
            @authorization.access_token
          end
        end
      end

    end
  end
end