class AppConfig < ApplicationRecord  
  
  def self.get
    AppConfig.prepare_config if @all_app_config.blank? or @app_config_last_checked_at.blank? or (Time.now.to_i - @app_config_last_checked_at.to_i) > 600
    @all_app_config || {}
  end

  def self.prepare_config
    @app_config_last_checked_at = Time.now
    @all_app_config = {}
    AppConfig.all.unscope(:where).map {|ap|
      @all_app_config[ap.name] ||= self.parse_config(ap)
    }
    @all_app_config
  end


  private
  def self.parse_config(preference)
    begin
      result = (preference.value_type == 'integer' ? preference.value.to_i : 
                  (preference.value_type == 'boolean' ? (preference.value == 'true' or preference.value == '1' ? true : false): 
                    (preference.value_type == 'array' ? preference.value.split(',') : 
                      (preference.value_type == 'hash' ? eval(preference.value) :
                        (preference.value_type == 'json' ? JSON.parse(preference.value) : preference.value.to_s )))))
    rescue => e
      Rails.logger.error("Error fething App Config data #{e.message} \n#{e.backtrace.join("\n")}")
      result =(preference.value_type == 'integer' ? 0 : 
                (preference.value_type == 'boolean' ? false: 
                  (preference.value_type == 'array' ? [] : 
                    (preference.value_type == 'hash' ? {} :
                      (preference.value_type == 'json' ? {} : "" )))))
    end
    result
  end

end