RSpec.describe AccountKeyClient do
  describe 'get_account_key' do
    let(:fake_email) { 'fake@email.com'}
    let(:fake_key) { 'Abajsk2190123u9i0klasdjb129' }
    let(:fake_response_key) { '182klasdmnxzjkasd9' }
    describe 'success request' do
      before do
        expect(HTTParty).to receive(:post)
        .with("#{AccountKeyClient::BASE_URI}#{AccountKeyClient::CREATE_ACCOUNT_PATH}",
          headers: { 'Content-Type'=>'application/json' },
          body: {
            email: fake_email,
            key: fake_key
          }).and_return(double('response', ok?: true, body: fake_response_key))
      end
      it 'should POST to external service' do
        AccountKeyClient.new.get_account_key(fake_email,fake_key)
      end

      it 'returns body if request went ok' do
        expect(AccountKeyClient.new.get_account_key(fake_email,fake_key)).to eq(fake_response_key)
      end

    end
    describe 'if service fails' do
      let(:fake_error){ {error: "Service not available" }}
      before do
        expect(HTTParty).to receive(:post)
        .with("#{AccountKeyClient::BASE_URI}#{AccountKeyClient::CREATE_ACCOUNT_PATH}",
          headers: { 'Content-Type'=>'application/json' },
          body: {
            email: fake_email,
            key: fake_key
          }).and_return(double('response', ok?: false, body: fake_error))
      end

      it 'raises a ServiceNotAvailable exception' do
        expect {AccountKeyClient.new.get_account_key(fake_email,fake_key) }.to raise_error(AccountKeyClient::ServiceNotAvailable)
      end
    end
  end
end