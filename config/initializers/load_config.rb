class APP_CONFIG
	def self.[](key)
		AppConfig.get[key]
	end
end

Hash.class_eval do
  # Changing Ruby hash behavier such that Hash will reposnd like normal object's attr_accessor for its keys
  def method_missing(method, *args, &block)
    begin
      val = self.fetch(method.to_s)
    rescue KeyError 
      begin 
        val = self.fetch(method.to_sym)
      rescue KeyError
        super
      end
    end
    # val = self.fetch(method, self.fetch(method.to_s, nil))
    # val.present? ? val : super
  end
end