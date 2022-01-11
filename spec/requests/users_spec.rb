require 'rails_helper'
def response_body
  JSON.parse(response.body, symbolize_names: true)
end
RSpec.describe "Users", type: :request do
  describe 'GET api/users' do
    it 'should be properly mapped' do
      expect(api_users_path).to eq('/api/users')
    end
    describe 'when there are no user on the DB' do
      it 'should return an empty list' do
        get api_users_url

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq({'users' => []})
      end
    end
    describe 'when no params are received' do
      before do
        User.destroy_all
        @user_1 = create(:user)
        @user_2 = create(:user)
      end

      after do
        User.destroy_all
      end

      it 'should return every user on the DB' do
        get api_users_url

        expect(response.status).to eq(200)
        expect(response_body[:users].length).to eq(2)
      end

      it 'should be ordered by creation date' do
        get api_users_url

        expect(response_body[:users].first[:email]).to eq(@user_2.email)
        expect(response_body[:users][1][:email]).to eq(@user_1.email)
      end
    end
    describe "when a param is received" do
      let(:fake_email) { 'test@gmail.com'}
      let(:fake_user) { build(:user, email: fake_email) }
      before do
        User.delete_all
        fake_user.save!
      end

      it 'filter users by received param' do
        get api_users_url, params: { email: fake_email}

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq({users: [UserSerializer.new(fake_user).serializable_hash]})
      end
    end

    describe 'When an error occurrs' do
      let (:exception_msg) { 'This is a test' }
      before do
        allow(User).to receive(:order).and_raise(StandardError, exception_msg).once
      end
      it 'should return a 500 with the message of the exception' do
        get api_users_url

        expect(response.status).to eq(500)
        expect(JSON.parse(response.body, symbolize_names: true)).to eq({errors: [exception_msg]})
      end
    end
  end

  describe 'POST /api/users' do
    describe 'success' do
      let(:fake_email) { 'fake_email@gmail.com' }

      before :each do
        User.where(email: fake_email).destroy_all
      end

      it 'returns recently created user with a random key' do
        user_to_create = {
          email: fake_email,
          password: 'test',
          full_name: 'My full name',
          phone_number: '+12309123'
        }

        post api_users_path, params: user_to_create

        expect(response.status).to eq(201)
        expect(response_body[:user][:email]).to eq(user_to_create[:email])
        expect(response_body[:user][:key]).not_to be_nil
        expect(response_body[:user][:password]).not_to eq(user_to_create[:password])
      end

      it 'triggers a worker for creating access key' do
        user_to_create = {
          email: fake_email,
          password: 'test',
          full_name: 'My full name',
          phone_number: '+12309123'
        }

        expect(AccountKeyServiceWorker).to receive(:perform_async)

        post api_users_path, params: user_to_create

        expect(response.status).to eq(201)
        expect(response_body[:user][:email]).to eq(user_to_create[:email])
      end
    end

    describe 'duplicated property' do
      fake_email = 'test@firstleaf.com'
      before do
        create(:user, email: fake_email)
      end
      it 'returns 422 with explanation within the body' do
        user_to_create = {
          email: fake_email,
          password: 'test',
          full_name: 'My full name',
          phone_number: '+12309123'
        }

        post api_users_path, params: user_to_create

        expect(response.status).to eq(422)
        expect(response_body[:errors]).to include(/Email has already been taken/)
      end
    end
  end
end
