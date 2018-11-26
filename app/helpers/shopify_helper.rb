module ShopifyHelper
	include HttpHelper

	ORDER_LIMIT = 250
	CUSTOMER_LIMIT = 250

	def get_customers
		url = '/admin/customers.json'
		total_customers = []
		tc = get_customer_count
		loop.with_index{|_,index|
			resp = access_shopify url,'get',{"limit" => CUSTOMER_LIMIT,"page" => index + 1}
			total_customers.push *resp["customers"] if resp.present?
			tc = tc - CUSTOMER_LIMIT
			break if tc <= 0
		}
		total_customers
	end

	def get_orders
		url = '/admin/orders.json'
		total_orders = []
		oc = get_order_count
		loop.with_index{|_,index|
			resp = access_shopify url,'get',{"limit" => ORDER_LIMIT,"page" => index + 1} 
			total_orders.push *resp["orders"] if resp.present?
			oc = oc - ORDER_LIMIT
			break if oc <= 0
		}
		total_orders
	end

	def get_customer_count
		url = '/admin/customers/count.json'
		resp = access_shopify url
		resp["count"] if resp.present?
	end

	def get_order_count
		url = '/admin/orders/count.json'
		resp = access_shopify url
		resp["count"] if resp.present?
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

	def access_shopify relative_url,http_method='get',params={}
		url = APP_CONFIG["shopify_domain"] + relative_url
		options = {:username => APP_CONFIG["shopify_username"],:password => APP_CONFIG["shopify_password"]}
		resp = http_request url,{}, options,http_method,params
		JSON.parse resp[1] if resp[0] 
	end
end