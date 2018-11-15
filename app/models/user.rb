class User < ApplicationRecord
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :validatable
	has_one :franchise
	enum role: [:user, :school, :admin]
	after_initialize :set_default_role, :if => :new_record?


	def set_default_role
	self.role ||= :user
	end

	def franchises 
		admin? ? Franchise.all : Franchise.where(:user_id => id)
	end

	def access? franchise_id
		admin? || (franchise.present? and franchise.id == franchise_id)
	end

end
