require 'rails_helper'
RSpec.describe AccountKeyServiceWorker, type: :worker do
  describe 'perform' do
    let(:fake_email) { 'david@gmail.com'}
    let(:fake_key) { '912381920kaiqwoeu8012'}
    it 'should call AccountKeyClient' do
      expect_any_instance_of(AccountKeyClient).to receive(:get_account_key)
        .with(fake_email, fake_key)

      AccountKeyServiceWorker.new.perform('email' => fake_email,'key' => fake_key)
    end
  end
end
