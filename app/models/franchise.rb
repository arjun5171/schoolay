class Franchise < ApplicationRecord
	belongs_to :user
	enum role: [:school, :master, :super_master]
	after_initialize :set_default_role, :if => :new_record?

	def set_default_role
		self.role ||= :school
	end

	def belongs?(user)
		user.present? and (user.admin? ||  user.id == user_id)
	end

	def get_transaction_data 
		{
			"name" => name,
			"phone_number" => phone_number,
			"email" => email,
			"address" => address,
		}
	end
end
