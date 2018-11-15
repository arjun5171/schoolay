class HomeController < ApplicationController
  include HomeHelper

  def index
    @franchise_list = current_user.try(:franchises)
    if params[:franchise_id].present? and current_user.try(:access?,params[:franchise_id])
      franchise = Franchise.find_by_id params[:franchise_id] 
      @franchise_data = franchise.transaction_data  if franchise.present?
    end
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
