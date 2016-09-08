class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  mattr_accessor :current_user
 
  def current_user #instance method to acces class variable
    @@current_user 
  end  

  before_action :set_locale
 
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end
