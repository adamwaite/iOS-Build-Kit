module BuildKit
  
  require 'rmagick'

  module Tasks

    def self.decorate_icon runner, task_opts
      task = DecorateIconTask.new({ runner: runner, opts: task_opts })
      task.run!
    end

    private

    class DecorateIconTask < BuildKitTask

      attr_reader :decorated_icons

      def initialize(attributes = {})
        super
        @decorated_icons = []
      end

      def run!
        decorate_icons!
        update_plist_icons!
        complete_task!
      end

      private

      def assert_requirements
        BuildKit::Utilities::Assertions.assert_required_config [:info_plist, :icon_dir], @runner
        BuildKit::Utilities::Assertions.assert_files_exist [@config.info_plist, @config.icon_dir]
      end

      def version_number_to_draw
        if @runner.has_completed_task? :increment_version
          @runner.store[:new_version_number][:full]
        else
          BuildKit::Utilities::VersionNumber.plist_version_number(runner.config.info_plist)[:full]
        end
      end

      def icon_files_to_decorate
        to_decorate = []
        Dir.glob("#{@config.icon_dir}/*.png").each do |filename|
          next if filename.include? "Decorated"
          to_decorate << filename
        end
        to_decorate
      end

      def decorated_icon_path icon_path
        original_img_filename = File.basename icon_path
        new_img_filename = "Decorated-" + original_img_filename
        icon_path.gsub(original_img_filename, new_img_filename)
      end

      def decorate_icons!
        icon_files_to_decorate.each do |img_path|
          @decorated_icons << create_decorated_version_of(img_path)
        end
      end

      def update_plist_icons!
        backup_plist = @runner.config.info_plist.gsub(/(\.plist)$/i, '.orig\1')
        FileUtils.remove_file backup_plist, true
        FileUtils.cp @runner.config.info_plist, backup_plist
        @runner.store[:backup_plist] = backup_plist

        icons = BuildKit::Utilities::PlistPal.read_array_value_in_plist(
          @runner.config.info_plist, "CFBundleIcons:CFBundlePrimaryIcon:CFBundleIconFiles")

        decorated_icons = icons.map{|icon| decorated_icon_path(icon)}
        BuildKit::Utilities::PlistPal.write_array_value_in_plist(
          @runner.config.info_plist, "CFBundleIcons:CFBundlePrimaryIcon:CFBundleIconFiles", decorated_icons)
      end

      def create_decorated_version_of icon_path
        original = Magick::ImageList.new icon_path
        decorated_icon = original.copy
        icon_dimension = original.rows

        background = Magick::Draw.new
        background.fill_opacity(0.75)
        background.rectangle(0, icon_dimension - (icon_dimension * 0.225), icon_dimension, icon_dimension)
        background.draw decorated_icon

        annotation_params = {
          gravity: Magick::SouthGravity, 
          pointsize: icon_dimension * 0.11 , 
          stroke: 'transparent', 
          fill: '#FFF', 
          font_family: "Helvetica CY", 
          font_weight: Magick::BoldWeight 
        }

        version_text = Magick::Draw.new
        version_text.annotate(decorated_icon, 0, 0, 0, icon_dimension * 0.05  , "#{version_number_to_draw}") do
          self.gravity = annotation_params[:gravity]
          self.pointsize = annotation_params[:pointsize]
          self.stroke = annotation_params[:stroke]
          self.fill = annotation_params[:fill]
          self.font_family = annotation_params[:font_family]
          self.font_weight = annotation_params[:font_weight]
        end

        new_img_full_path = decorated_icon_path(icon_path)
        decorated_icon.write(new_img_full_path)

        new_img_full_path
      end

      def complete_task!
        message = "Icons have been decorated with #{version_number_to_draw}. They are here: \n" + @decorated_icons.join(",\n     ")
        @runner.task_completed! :decorate_icon, message, message 
      end

    end

  end
        
end