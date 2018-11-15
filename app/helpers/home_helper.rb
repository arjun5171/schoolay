module HomeHelper

	def generate_csv headers,data
		require 'csv'
	    CSV.generate do |csv|
	      csv << headers
	      data.each{|dat| csv << dat }
	    end
	end

end
