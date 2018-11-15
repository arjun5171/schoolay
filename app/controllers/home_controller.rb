class HomeController < ApplicationController
  def index
    @franchise_list = current_user.try(:franchises)
    if params[:franchise_id].present? and current_user.try(:access?,params[:franchise_id])
      franchise = Franchise.find_by_id params[:franchise_id] 
      @franchise_data = franchise.get_transaction_data if franchise.present?
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
  
end
