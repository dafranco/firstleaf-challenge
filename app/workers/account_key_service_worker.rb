class AccountKeyServiceWorker
  include Sidekiq::Worker

  def perform(opts)
    AccountKeyClient.new.get_account_key(opts['email'], opts['key'])
  end
end
