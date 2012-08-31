module Polka
  class Bootstrapper
    def initialize(home_dir, dotfile_dir)
      @home_dir = home_dir
      @dotfile_dir = dotfile_dir
      DotfileGroup.all_files = dotfiles_in_dotfile_dir

      @symlinks = DotfileGroup.new
      @excluded = DotfileGroup.new
      exclude("Dotfile")
    end

    def self.from_dotfile(dotfile, home_dir)
      bootstrapper = new(home_dir, File.expand_path(File.dirname(dotfile)))
      bootstrapper.instance_eval(dotfile.read)

      return bootstrapper
    end

    def symlink(*files)
      if files.size == 2 && files.last.class == Hash && files.last[:as]
        df = create_dotfile(files[0], files[1][:as])
        add_dotfile_to_group(df, @symlinks)
      else
        add_files_to_group(files, @symlinks)
      end
    end

    def exclude(*files)
      add_files_to_group(files, @excluded)
    end

    def setup
      @symlinks.setup
    end

    private
    def add_files_to_group(files, group)
      group.add_all_other_files if files.delete(:all_other_files)
      dotfiles = files.map { |fn| create_dotfile(fn) }
      dotfiles.each { |df| add_dotfile_to_group(df, group) }
    end

    def add_dotfile_to_group(dotfile, group)
      group.add([dotfile])
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
