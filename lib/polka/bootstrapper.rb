module Polka
  class Bootstrapper
    def initialize(home_dir, dotfile_dir)
      @home_dir = home_dir
      @dotfile_dir = dotfile_dir
      DotfileGroup.all_files = dotfiles_in_dotfile_dir

      symlinking = lambda { |dest, src| FileUtils.ln_s(dest, src) }
      copying = lambda { |dest, src| FileUtils.cp(dest, src) }

      @symlink = DotfileGroup.new(symlinking, "  Symlinking files".light_blue)
      @copy = DotfileGroup.new(copying, "  Copying files".light_blue)
      @parsed_copy = DotfileGroup.new(Operations::ParsedCopying, "  Parsing and copying files".light_blue)
      @inclusive_groups = [@symlink, @copy, @parsed_copy]
      @exclude = DotfileGroup.new
      exclude("Dotfile")
    end

    def self.from_dotfile(dotfile, home_dir)
      bootstrapper = new(home_dir, File.expand_path(File.dirname(dotfile)))
      bootstrapper.instance_eval(dotfile.read)

      return bootstrapper
    end

    # TODO: the structure of copy and the rest is the same,
    # refactor into one method?
    [:symlink, :exclude].each do |var|
      define_method(var) do |*files|
        group = instance_variable_get("@#{var}")
        if file_with_options?(files)
          add_file_with_options_to_group(files, group)
        else
          group.add_all_other_files if files.delete(:all_other_files)
          add_files_to_group(files, group)
        end
      end
    end

    def copy(*files)
      if file_with_options?(files)
        group = erb?(files[0]) ? @parsed_copy : @copy
        add_file_with_options_to_group(files, group)
      else
        error_msg  = "Cannot copy :all_other_files, please copy files explicitly."
        raise ArgumentError, error_msg if files.include?(:all_other_files)

        erb = files.select { |fn| erb?(fn) }
        not_erb = files - erb
        add_files_to_group(erb, @parsed_copy)
        add_files_to_group(not_erb, @copy)
      end
    end

    def setup
      Polka.log "\nStarting Dotfile Setup with Polka...\n".green
      @inclusive_groups.each(&:setup)
      Polka.log "\nSetup completed. Enjoy!\n".green
    end

    private
    def add_files_to_group(files, group)
      dotfiles = files.map { |fn| create_dotfile(fn) }
      group.add(dotfiles) unless dotfiles.empty?
    end

    def add_file_with_options_to_group(file_with_options, group)
      filename = file_with_options[0]
      homename = file_with_options[1][:as]

      group.add([create_dotfile(filename, homename)])
    end

    def erb?(filename)
      filename =~ /\.erb$/
    end

    def file_with_options?(files)
      return false unless files.size == 2 && files.last.class == Hash && files.last[:as]
      unless files[0] == :all_other_files
        return true
      else
        raise ArgumentError, "Cannot add :all_other_files with :as options"
      end
    end

    def dotfiles_in_dotfile_dir
      files = Dir.new(@dotfile_dir).entries - %w(.. .)
      files.map { |fn| create_dotfile(fn) }
    end

    def create_dotfile(filename, homename=nil)
      dotfile_path = File.join(@dotfile_dir, filename)
      home_path = File.join(@home_dir, homename || filename)
      Dotfile.new(dotfile_path, home_path)
    end
  end
end
