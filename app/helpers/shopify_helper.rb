module ShopifyHelper
	include HttpHelper

	def get_customers
		url = '/admin/customers.json'
		access_shopify url
	end

	def access_shopify relative_url,http_method='get'
		url = APP_CONFIG["shopify_domain"] + relative_url
		options = {:user_name => "support@schoolay.com",:password => "9524732613"}
		resp = http_request url,{}, options,http_method
		JSON.parse resp[1] if resp[0] 
	end
end