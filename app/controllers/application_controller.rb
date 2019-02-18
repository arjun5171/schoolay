class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def set_current_franchise
  	franchise_id = params[:franchise_id] || params[:id] 
  	@current_franchise = Franchise.find_by_id(franchise_id)  if franchise_id.present? and current_user.try(:access?,franchise_id)
  end

end