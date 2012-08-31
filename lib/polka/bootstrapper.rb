module Polka
  class Bootstrapper
    def initialize(home_dir, dotfile_dir)
      @home_dir = home_dir
      @dotfile_dir = dotfile_dir
      @symlinks = []
      @excluded = []
      exclude("Dotfile")
    end

    def self.from_dotfile(dotfile, home_dir)
      bootstrapper = new(home_dir, File.dirname(dotfile))
      bootstrapper.instance_eval(dotfile.read)

      return bootstrapper
    end

    def symlink(*files)
      @symlinks = add_to_group(@symlinks, files)
    end

    def exclude(*files)
      @excluded = add_to_group(@excluded, files)
    end

    def setup
      @symlinks = files_in_dotfile_dir if @symlinks.include?(:all_other_files)
      syms = @symlinks - @excluded
      syms.each(&:setup)
    end

    private
    def dotfile_path(filename)
      File.join(@dotfile_dir, filename)
    end

    def home_path(filename)
      File.join(@home_dir, filename)
    end

    def files_in_dotfile_dir
      files = Dir.new(@dotfile_dir).entries - %w(.. .)
      make_dotfiles(files)
    end

    def add_to_group(group, files)
      if files.include?(:all_other_files) || group.include?(:all_other_files)
        [:all_other_files]
      else
        group + make_dotfiles(files)
      end
    end

    def make_dotfiles(files)
      files.map { |fn| Dotfile.new(dotfile_path(fn), home_path(fn)) }
    end
  end
end
