class AccountKeyClient
  class ServiceNotAvailable < StandardError; end
  # This should be stored by env. As this is a simple project I
  # kept the uri hardcoded
  BASE_URI = 'https://account-key-service.herokuapp.com/'

  CREATE_ACCOUNT_PATH = 'v1/account'

  def get_account_key(email, key)
    response = HTTParty.post(create_url(CREATE_ACCOUNT_PATH),
      headers: { 'Content-Type'=>'application/json' },
      body: {
        email: email,
        key: key
      }
    )
    ## WARNING: There is no documentation about the different
    ## service errors and http statuses associated to them.
    ## For this particular example I'm considering that if status <> 200
    ## then the service is not available.
    ## Other scenarios could be malformed params, auth, user not found, etc.
    return response.body if response.ok?

    raise ServiceNotAvailable.new(response&.body)
  end

  private

  def create_url(relative_path)
    "#{BASE_URI}#{relative_path}"
  end
end