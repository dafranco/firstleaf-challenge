class AccountKeyServiceWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    received_key = AccountKeyClient.new.get_account_key(user.email, user.key)
    user.update! account_key: received_key
  end
end
