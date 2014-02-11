def clear_reports
	Dir.glob("reports/*.json").each { |f| File.delete f }
end