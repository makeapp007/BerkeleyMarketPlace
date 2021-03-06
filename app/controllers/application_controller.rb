require 'time'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception unless Rails.env.test?
  # protect_from_forgery with: :null_session
  
  helper_method :current_user, :check_superuser, :safe_url, :can_visit_before_login
  
  before_filter :is_logged_in
  skip_after_action :verify_same_origin_request
  
  def can_visit_before_login
    (request.path == "/") || (request.path =~ /auth/)
  end
  
  def is_logged_in
    if current_user.nil? && !can_visit_before_login
      redirect_to("/")
    end
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
  
  def check_superuser
    if not current_user.superuser?
      redirect_to("/", flash: { alert: "You are not allowed to access the page" })
    end
  end
  
  def safe_url url
    if not(url.include? "https")
      url = url.sub("http", "https")
    end
    url
  end
  
  def index
    
    logger.debug "params to applicaiton#index: #{params}"
    
    filterrific_params = Post.complete_filterrific_params(params[:filterrific])
    
    @current_category_id = params[:category_id]
    @current_subcategory_id = params[:subcategory_id]
    
    if not @current_subcategory_id.nil?
      filterrific_params[:choose_category] = Post.category_tag_by_id(@current_category_id, @current_subcategory_id)
    elsif not @current_category_id.nil?
      filterrific_params[:choose_category] = Post.all_category_tag_by_id(@current_category_id)
    end
    
    logger.debug "index filterrific params: %s" % filterrific_params
    
    @sorted_by = params[:sorted_by]
    filterrific_params[:sorted_by] = params[:sorted_by]
    
    @filterrific = initialize_filterrific(Post, filterrific_params) or return
    @posts = @filterrific.find.page(params[:page])
    
  end
  
end
