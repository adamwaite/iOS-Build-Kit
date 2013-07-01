module ContiniOSIntegration
  
  require 'rmagick'
  require "./utils/existing_version_number.rb"
  
  def self.decorate_icon
    
    # instance
    runner = ContiniOSIntegration::CITaskRunner.instance
    
    # requirements
    runner.ensure_required_config [:icon_path, :plist_path]
                
    # reference all of the icon files
    icon_dir = runner.get_config :icon_path
		icon_files = lambda do
      icon_paths = []
      Find.find("#{icon_dir}") do |path| 
        icon_paths << path if ((path =~ /.*\.png$/) and (!path.include? "_build"))
      end
      icon_paths
    end.call
		icon_files.map! { |icon| icon = "#{icon}" }
    
    # determine version number to draw
    if runner.get_config(:new_version_number).nil?
      existing_version = existing_version_number
      puts existing_version.inspect
      version_number_to_draw = existing_version[:full]
      puts "the increment_version task was not run, the existing version number will be rendered: #{existing_version_number[:full]}"
    else
      version_number_to_draw = runner.get_config :new_version_number
      puts "will render incremented version number: #{runner.get_config :new_version_number}"
    end
    
    # for each icon...
    icon_files.each do |icon_path|
      
      # copy the icon to play with
      raw_icon = Magick::ImageList.new(icon_path)
      decorated_icon = raw_icon.copy
      
      # calculate dimension
      icon_dimension = raw_icon.rows
      
      # create a container and draw into the copy
      background = Magick::Draw.new
      background.fill_opacity(0.5)
      background.rectangle(0, icon_dimension - (icon_dimension * 0.225), icon_dimension, icon_dimension)
      background.draw decorated_icon
      
      # set parameters for the annotation
      annotation_params = { :gravity => Magick::SouthGravity, :pointsize => icon_dimension * 0.11 , :stroke => 'transparent', :fill => '#FFF', :font_family => "Helvetica CY", :font_weight => Magick::BoldWeight }
      
      # draw the version number
      new_v_number = runner.get_config :new_version_number
      if !new_v_number.nil?
        version_text = Magick::Draw.new
        version_text.annotate(decorated_icon, 0, 0, 0, icon_dimension * 0.05  , "#{new_v_number}") do
          self.gravity = annotation_params[:gravity]
          self.pointsize = annotation_params[:pointsize]
          self.stroke = annotation_params[:stroke]
          self.fill = annotation_params[:fill]
          self.font_family = annotation_params[:font_family]
          self.font_weight = annotation_params[:font_weight]
        end
      end
      
      # create a new file name
      new_file_name = "#{icon_path}".sub('.png', "") + "_build.png"
      
      # write the file to disk
      decorated_icon.write(new_file_name)
      puts "#{new_file_name} written to disk successfully"
      
    end
  
    # success message
    runner.success_msg "decorate_icons completed successfully"
        
  end
        
end