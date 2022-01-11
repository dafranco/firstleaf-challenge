class CreateUserService

  def initialize(user_repo)
    @user_repo = user_repo
  end

  def create_from_params(params)
    user = user_repo.create!(params)
    AccountKeyServiceWorker.perform_async(user.email, user.key)
    user
  end

  private

  attr_reader :user_repo
end