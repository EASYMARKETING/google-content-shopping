module Google
  module Content
    module Shopping

      class ClientAccounts
        include Enumerable
        extend  Forwardable
        def_delegators :@accounts, :length, :each

        def initialize(new_accounts = [])
          @accounts = new_accounts
        end

        def <<(account)
          account.is_a? ClientAccount ? @accounts << account : false
        end

        def reverse
          ClientAccounts.new(@accounts.reverse)
        end
      end

    end
  end
end