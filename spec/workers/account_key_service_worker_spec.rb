require 'rails_helper'
RSpec.describe AccountKeyServiceWorker, type: :worker do
  describe 'perform' do
    let(:fake_email) { 'david@gmail.com'}
    let(:fake_key) { '912381920kaiqwoeu8012'}
    let!(:user) { create(:user) }

    it 'should call AccountKeyClient' do
      expect_any_instance_of(AccountKeyClient).to receive(:get_account_key)
        .with(user.email, user.key)

      AccountKeyServiceWorker.new.perform(user.id)
    end

    it 'should update user with received account key' do
      user = create(:user)
      fake_key = 'fakekey'

      expect_any_instance_of(AccountKeyClient).to receive(:get_account_key)
        .with(user.email, user.key)
        .and_return(fake_key)

      AccountKeyServiceWorker.new.perform(user.id)

      expect(user.reload.account_key).to eq(fake_key)
    end
  end
end
