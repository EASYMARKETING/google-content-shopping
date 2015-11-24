module Google
  module Content
    module Shopping

      class Auth
        def initialize(content_for_shopping_config_filelocation, credentials = nil)
          @config_file_location = content_for_shopping_config_filelocation
          config_file_content   = YAML::load_file(content_for_shopping_config_filelocation)

          config_file_content[:authentication][:oauth2_token].merge!(credentials) if credentials

          config                 = AdsCommon::Config.new(config_file_content)
          @credential_handler    = AdsCommon::CredentialHandler.new(config)
          @authorization_handler = AdsCommon::Auth::OAuth2Handler.new(config, 'https://www.googleapis.com/auth/content')
        end

        def access_token_header
          @authorization_handler.auth_string(@credential_handler.credentials)
        end

        # SHOULD ONLY BE USED TO FETCH THE AUTH_TOKEN WHEN IT IS NOT PRESENT
        # IN THE CONFIG FILE OR HAS EXPIRED FOR GOOD
        def fetch_auth_token
          token = run_authorization do |auth_url|
            puts "Please navigate to URL:\n\t%s" % auth_url
            print 'log in and type the verification code: '
            verification_code = gets.chomp
            verification_code
          end

          # Store the new config value in the config file
          AdsCommon::Utils.save_oauth2_token(@config_file_location, token)
        end

        private

        def run_authorization(&block)
          token = @authorization_handler.get_token()

          # If token is invalid ask for a new one.
          if token.nil?
            begin
              credentials = @credential_handler.credentials
              token = @authorization_handler.get_token(credentials)
            rescue AdsCommon::Errors::OAuth2VerificationRequired => e
              verification_code = (block_given?) ? yield(e.oauth_url) : nil
              # Retry with verification code if one provided.
              if verification_code
                @credential_handler.set_credential(
                    :oauth2_verification_code, verification_code)
                retry
              else
                raise e
              end
            end
          end
          return token
        end
      end

    end
  end
end
