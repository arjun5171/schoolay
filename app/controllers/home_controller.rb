class HomeController < ApplicationController

  before_action :set_current_franchise

  include HomeHelper

  def index
    @franchise_list = current_user.try(:franchises)    
    @current_franchise = @franchise_list.try(:first) if @current_franchise.nil?
    @franchise_data = @current_franchise.transaction_data  if @current_franchise.present?
  end

  def contact
  end

  def about
  end
  
  def add_school
  end

  def create_school
  end

  def login
  end

  def logout
  end

  def order_details
  end

  def download_csv
    data = JSON.parse params["data"]
    csv = generate_csv params["headers"],data
    filename = params["filename"] || "report"
    respond_to do |format|
      format.html
      format.csv { send_data csv,:filename => filename+".csv"}
    end
  end
  
end
