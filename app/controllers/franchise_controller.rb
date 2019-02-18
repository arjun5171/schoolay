class FranchiseController < ApplicationController

	before_action :set_current_franchise
	include ShopifyHelper

	def index
	end

	def show
	end

	def sales_report
		@purchased_items = Hash.new {|h,k| h[k] = [] }
		get_orders.each do |order| 
			line_item = order["line_items"][0]
			@purchased_items[line_item["title"]] << line_item["price"].to_f if line_item["title"].include? @current_franchise.name 
		end
	end
end