RSpec.describe CreateUserService do

  describe '#create_from_params' do
    it 'should call to create! with received params' do
      fake_email = 'fake_email'
      fake_key = 'fake_key'
      fake_created_user = spy('User', id: 123, email: fake_email, key: fake_key)
      fake_user_repo = spy('User', create!: fake_created_user)
      fake_params = {}

      CreateUserService.new(fake_user_repo).create_from_params(fake_params)

      expect(fake_user_repo).to have_received(:create!).with(fake_params)
    end

    it 'should call AccountKeyServiceWorker' do
      fake_email = 'fake_email'
      fake_key = 'fake_key'
      fake_created_user = spy('User', id: 123, email: fake_email, key: fake_key)
      fake_user_repo = spy('User', create!: fake_created_user)
      fake_params = {}
      expect(AccountKeyServiceWorker).to receive(:perform_async)
        .with(fake_created_user.id)

      CreateUserService.new(fake_user_repo).create_from_params(fake_params)
    end

    it 'should return recently created user' do
      fake_email = 'fake_email'
      fake_key = 'fake_key'
      fake_created_user = spy('User', email: fake_email, key: fake_key)
      fake_user_repo = spy('User', create!: fake_created_user)
      fake_params = {}

      expect(CreateUserService.new(fake_user_repo).create_from_params(fake_params)).to eq(fake_created_user)
    end

  end

end