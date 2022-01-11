
RSpec.describe User, type: :model do
  describe 'validations' do
    describe 'required fields' do
      describe 'Active record schema must contain' do
        [
          'email',
          'phone_number',
          'full_name',
          'password_digest',
          'key',
          'account_key',
          'metadata'
        ].each do |field|
          it field do
            expect(User.column_names).to include(field)
          end
        end
      end
      describe 'an error should be raised when the record' do
      let(:required_data) { {email: 'fake@gmail.com', password: 'securepwd', phone_number:'+123789123', key: 'superkey'} }
        it 'doesn\'t have an email' do
          user = User.new(required_data.merge(email: nil))
          expect {user.save!}.to raise_error(ActiveRecord::NotNullViolation, /null value in column \"email\" violates not-null constraint/)
        end
        it 'doesn\'t have a phone_number' do
          user = User.new(required_data.merge(phone_number: nil))
          expect {user.save!}.to raise_error(ActiveRecord::NotNullViolation, /null value in column \"phone_number\" violates not-null constraint/)
        end
        it 'doesn\'t have a password' do
          user = User.new(required_data.merge(password: nil))
          expect {user.save!}.to raise_error(ActiveRecord::RecordInvalid, /Password can't be blank/)
        end
      end
    end
    describe 'uniqueness' do
      [:email, :key, :account_key, :phone_number].each do |field|
        it "#{field} must be unique" do
          fake_user = build(:user)
          fake_user.send("#{field}=", 'fake_value')
          fake_user.save!

          second_user = build(:user)
          second_user.send("#{field}=", 'fake_value')

          expect { second_user.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  describe 'generate_key' do
    describe 'if record has no key set' do
      it 'stores generated value on key attribute' do
        fake_uuid = 'fake_uuid'
        allow(SecureRandom).to receive(:uuid).and_return(fake_uuid)
        fake_user = User.new
        expect(fake_user).to receive(:key=).with(fake_uuid)
        fake_user.generate_key
      end
      it 'calls secure random module' do
        fake_uuid = 'fake_uuid'
        expect(SecureRandom).to receive(:uuid).and_return(fake_uuid)
        User.new.generate_key
      end
    end

    describe 'if record has key set' do
      it 'keeps original key' do
        fake_key = 'fake'
        fake_user = User.new(key: fake_key)
        fake_user.generate_key
        expect(fake_user.key).to eq(fake_key)
      end
    end
  end

  describe 'callbacks' do
    it 'calls generate key when created' do
      fake_user = User.new(email: 'fake', password: 'fake', phone_number: 'fake')
      expect(fake_user).to receive(:generate_key).and_call_original
      fake_user.save!
    end
  end
end