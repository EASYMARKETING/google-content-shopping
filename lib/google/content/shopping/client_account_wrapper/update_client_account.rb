module Google
  module Content
    module Shopping

      class UpdateClientAccount < ClientAccountWrapper
        # If the 'adwords_accounts' element is not included in an update
        # request, the existing associated AdWords accounts settings will be
        # unchanged and returned with the response.
        #
        # As long as 'adwords_accounts' is included in the request, the values
        # contained are interpreted as the complete settings. For example, if
        # your account was previously associated with the active AdWords account
        # 222-333-4444 by including:
        # {
        #   adwords_accounts: [
        #     {status: :active, number: '222-333-4444'}
        #   ]
        # }
        # and you submit an update containing:
        # {
        #   adwords_accounts: [
        #     {status: :active, number: '123-456-7890'},
        #     {status: :inactive, number: '234-567-8901'}
        #   ]
        # }
        # then the association with 222-333-4444 will be removed.
        #
        # If you would like to remove all associated AdWords accounts, submit an
        # update with an empty 'adwords_accounts' element.
        def perform(client_account, options = {})
          @request_body = client_account.to_xml

          payload = options.merge({body: request_body})
                           .merge(standard_header)

          response = self.class.put("/content/v1/#{parent_account_number}/managedaccounts/#{client_account_number}",
                                     payload)

          parse_response(response)
        end
      end

    end
  end
end