class AuthenticationController < ApplicationController
  skip_before_action :require_login

  def login
    @user = User.find_by(password: params[:password])
    @user.update token: SecureRandom.uuid
    render json: @user.as_json(only: :token)
  end
end
