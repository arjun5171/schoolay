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
		cust_count = get_customer_count
		orders = get_orders
		purchased_orders = []
		orders.map{|order| purchased_orders << order if order["line_items"][0]["title"].include? franchise.name }
		purchased_orders = purchased_orders.compact
		purchased_customers = purchased_orders.collect{|order| order["customer"].try(:[],"id")}.compact.uniq.length
		total_sale = orders.inject(0){|sum,order| sum += order["total_price"].to_f}
		{
			"total_customers" => cust_count,
			"total_orders" => purchased_orders,
			"avg_sale_value" =>  (total_sale / cust_count).round(2),
			"total_sales" => total_sale,
			"purchased_customers" => purchased_customers,
			"sale_percentage" => (purchased_customers.to_f/cust_count*100).round(2),
			"expected_sales" => (total_sale * purchased_customers.to_f/cust_count).round(2)
		}
	end

	def access_shopify relative_url,http_method='get',params={}
		url = APP_CONFIG["shopify_domain"] + relative_url
		options = {:username => APP_CONFIG["shopify_username"],:password => APP_CONFIG["shopify_password"]}
		resp = http_request url,{}, options,http_method,params
		JSON.parse resp[1] if resp[0] 
	end
end