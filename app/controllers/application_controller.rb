class ApplicationController < ActionController::Base
  before_action :require_login
  skip_before_action :verify_authenticity_token

  private

  def require_login
    begin
      token = request.headers.fetch(:authorization)
      @user = User.find_by(token: token)
      render html: 'Access Denied', status: 403 unless @user
    rescue KeyError
      render html: 'Access Denied', status: 403
    end
  end
end
