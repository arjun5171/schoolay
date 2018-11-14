class APP_CONFIG
	def self.[](key)
		AppConfig.get[key]
	end
end