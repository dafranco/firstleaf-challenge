class Api::UsersController < ApplicationController
  rescue_from StandardError, with: :internal_error
  rescue_from ActiveRecord::RecordInvalid, with: :creation_error

  ## Design comments:
  ## 1. For #index I used a controller -> Model connection
  ## 2. For #create I used a pretty common 'Service-oriented' approach
  ## 3. A third option of architechturing the app I like is Uncle bob's clean architechture
  ##    but it's not so common in rails community. Check https://github.com/yukas/clean-blog-rails

  def index
    query = User.order(created_at: :desc)

    unless find_user_params.empty?
      query.where(find_user_params)
    end

    render json: query, root: 'users', each_serializer: UserSerializer
  end

  def create
    user = CreateUserService.new(User).create_from_params(create_user_params)

    render json: user, serializer: UserSerializer, status: 201
  end

  private

  def create_user_params
    params.permit(:email, :phone_number, :full_name, :password, :metadata)
  end

  def find_user_params
    params.permit(:email, :full_name, :metadata)
  end

  def internal_error(exception)
    render json: { errors: [exception.message] }, status: 500
  end

  def creation_error(exception)
    errors = []

    exception.record.errors.each do |error_msg|
      errors << error_msg
    end

    render json: { errors: [exception.message] }, status: 422
  end
end
