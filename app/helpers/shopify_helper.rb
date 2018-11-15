module ShopifyHelper
	include HttpHelper

	def get_customers
		url = '/admin/customers.json'
		resp = access_shopify url
		resp["customers"] if resp.present?
	end

	def get_orders
		url = '/admin/orders.json'
		resp = access_shopify url
		resp["orders"] if resp.present?
	end

	def get_transaction_data(franchise)
		cust = get_customers
		orders = get_orders
		purchased_customers = []
		orders.map{|order| purchased_customers << cust.find{|customer| customer["id"] == order["customer"]["id"]} if order["line_items"][0]["title"].include? franchise.name }
		purchased_customers = purchased_customers.compact
		total_sale = cust.inject(0){|sum,customer| sum += customer["total_spent"].to_f}
		{
			"total_customers" => cust,
			"avg_sale_value" =>  total_sale / cust.length,
			"total_sales" => total_sale,
			"purchased_customers" => purchased_customers,
			"sale_percentage" => (purchased_customers.length.to_f/cust.length)*100,
			"expected_sales" => total_sale * (purchased_customers.length.to_f/cust.length)
		}
	end

	def access_shopify relative_url,http_method='get'
		url = APP_CONFIG["shopify_domain"] + relative_url
		options = {:username => APP_CONFIG["shopify_username"],:password => APP_CONFIG["shopify_password"]}
		resp = http_request url,{}, options,http_method
		JSON.parse resp[1] if resp[0] 
	end
end