class AuthenticationController < ApplicationController
  skip_before_action :require_login

  def login
    @user = User.find_by(password: params[:password])
    if @user
      @user.update token: SecureRandom.uuid
      render json: @user.as_json(only: [:avatar, :username, :token])
    else
      render html: 'Wrong Password', status: 408
    end
  end
end
