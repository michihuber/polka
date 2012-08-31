module Polka
  class Bootstrapper
    def initialize(home_dir, dotfile_dir)
      @home_dir = home_dir
      @dotfile_dir = dotfile_dir
      DotfileGroup.all_files = dotfiles_in_dotfile_dir

      symlinking = lambda { |dest, src| FileUtils.ln_s(dest, src) }
      copying = lambda { |dest, src| FileUtils.cp(dest, src) }

      @symlink = DotfileGroup.new(symlinking)
      @copy = DotfileGroup.new(copying)
      @inclusive_groups = [@symlink, @copy]
      @exclude = DotfileGroup.new
      exclude("Dotfile")
    end

    def self.from_dotfile(dotfile, home_dir)
      bootstrapper = new(home_dir, File.expand_path(File.dirname(dotfile)))
      bootstrapper.instance_eval(dotfile.read)

      return bootstrapper
    end

    [:symlink, :copy, :exclude].each do |var|
      define_method(var) do |*files|
        add_files_to_group(files, instance_variable_get("@#{var}"))
      end
    end

    def setup
      @inclusive_groups.each(&:setup)
    end

    private
    def add_files_to_group(files, group)
      dotfiles =  if files.size == 2 && files.last.class == Hash && files.last[:as]
                    [create_dotfile(files[0], files[1][:as])]
                  else
                    group.add_all_other_files if files.delete(:all_other_files)
                    files.map { |fn| create_dotfile(fn) }
                  end

      group.add(dotfiles) unless dotfiles.empty?
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
