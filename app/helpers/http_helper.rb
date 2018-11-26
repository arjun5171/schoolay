module HttpHelper
	require 'net/http'
	require 'net/https'

  def http_request(url, headers={}, options={}, method='get',params={}, body='')
    result = get_response(url, headers, options, method,params, body)
    response = result[1] #result[1] has the response object
    response_cookies = result[3]
    result={"success"=>result[0], "response_code"=> response.present? ? response.code.to_i : result[2]}
    begin
      if response.present?
        res_body = response.body
        rct = (options[:response_content_type] || response.content_type)
      end
      result["body"] = res_body
    rescue => e
      Rails.logger.error("Error while processing proxy request #{url}. \n#{e.message}\n#{e.backtrace.join('\n')}")
      result["response_code"] = 500  # Internal server error
      result["success"] = false
    end
    [result["success"], result["body"], result["response_code"].to_i , response_cookies]
  end

  def get_response(url, headers={}, options={}, method='get',params={}, body='')
    success = true
    response_code = 200
    res_body = ""
    headers = headers || {}
    options = options || {}
    headers['User-Agent'] ||= "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2)"
    method = method || 'get'
    begin
      parsed_uri = nil
      for i in 1..3 do #In case of redirect due to HTTP 301 - repeat only 3 times
        begin
          parsed_uri = URI.parse(URI.encode(url)) if parsed_uri.blank?
          parsed_uri.query = URI.encode_www_form( params )
          #headers['Authorization'] = "Basic "+Base64.encode64("#{options.delete(:username)}:#{options.delete(:password)}") if options[:username].present?
          if (method == 'get') || (method == 'head')
            req = Net::HTTP::Get.new(parsed_uri.request_uri, headers)
          elsif method == 'post' or method == 'put'
            if options[:full_path]
              req = Net::HTTP::Post.new(url, headers) if method == 'post'
              req = Net::HTTP::Put.new(url, headers) if method == 'put'
            else
              req = Net::HTTP::Post.new(parsed_uri.path, headers) if method == 'post'
              req = Net::HTTP::Put.new(parsed_uri.path, headers) if method == 'put'
            end
            if body.instance_of? Hash
              req.set_form_data body
            else
              req.body = body
            end
          end
          req.basic_auth options.delete(:username), options.delete(:password) if options[:username].present?
          options[:open_timeout] = 60 unless options[:open_timeout].present?
          options[:read_timeout] = 60 unless options[:read_timeout].present?
          Rails.logger.debug "Sending request remote_url #{parsed_uri.host} #{parsed_uri.port} #{method} #{parsed_uri.request_uri}, #{headers}, #{options.inspect}, #{req.inspect}"
          if url.include?("https")
            options[:use_ssl] = true
            options[:verify_mode] = OpenSSL::SSL::VERIFY_NONE
          end
          response = Net::HTTP.start(parsed_uri.host, parsed_uri.port, options.except(:full_path)) {|http| http.request(req)}

          Rails.logger.debug "Received response #{response} #{response.content_type}"
          #if response.code == "301" || response.code == "302"
          if /3\d\d/.match(response.code).present? and !options[:disable_retry]
            redirect_path = response.header['location']
            if (redirect_path.match(/^\/.*/)).present?
              parsed_uri.path = redirect_path
            else
              url = redirect_path
              parsed_uri = nil
            end
          else
            break
          end
        rescue => e
          Rails.logger.error("Error while processing proxy request #{url}. \n#{e.message}\n#{e.backtrace.join("\n")}")
          response_code = 500  # Internal server error
          success = false
          sleep(0.1)
        end
      end

      response_code = response.code
      response_cookies = response.response['set-cookie']
      success = /2\d\d/.match(response_code).present?
    rescue => e
      Rails.logger.error("Error while processing proxy request #{url}. \n#{e.message}\n#{e.backtrace.join("\n")}")
      response_code = 500  # Internal server error
      success = false
    end
    resp = [success, response, response_code.to_i , response_cookies]
    resp
  end

  module_function :http_request, :get_response
end
