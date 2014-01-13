class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authenticate_app_from_token!

  protected
    def authenticate_app_from_token!
      authenticate_or_request_with_http_token do |token, options|
        @permitted_app = PermittedApp.where(authentication_token: token).first
      end
    end
end
