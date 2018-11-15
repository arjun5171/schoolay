class Franchise < ApplicationRecord
	include ShopifyHelper
	belongs_to :user
	enum role: [:school, :master, :super_master]
	after_initialize :set_default_role, :if => :new_record?

	def set_default_role
		self.role ||= :school
	end

	def belongs?(user)
		user.present? and (user.admin? ||  user.id == user_id)
	end

	def transaction_data 
		t_data = attributes.slice("name","phone_number","email","address")
		t_data = t_data.merge get_transaction_data(self)
	end
end
