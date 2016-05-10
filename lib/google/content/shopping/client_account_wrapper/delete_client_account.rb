module Google
  module Content
    module Shopping

      class DeleteClientAccount < ClientAccountWrapper

        # When you delete a client account, all of the items in that client's
        # feeds will be removed from the Google search index in approximately
        # one day.
        def perform
          response = self.class.delete("/content/v2/#{parent_account_number}/accounts/#{client_account_number}",
                                       standard_header)

          response.blank?
        end
      end

    end
  end
end
