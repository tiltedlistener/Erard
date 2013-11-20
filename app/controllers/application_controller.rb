class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper

  before_filter :set_constants

  def set_constants 
  	  @logged_in = check_user_state()
  	  @current_uri = request.env['PATH_INFO']
  	  @controller = params[:controller]
  	  @action = params[:action]
  	  @id = params[:id]
  end

end
