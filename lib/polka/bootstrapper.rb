module Polka
  class Bootstrapper
    attr :symlinks, :excluded
    def initialize(home_dir, dotfile_dir)
      @home_dir = home_dir
      @dotfile_dir = dotfile_dir
      @symlinks = []
      @excluded = ["Dotfile"]
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
      add_all_other_files
      syms = @symlinks - @excluded
      syms.each { |fn| FileUtils.ln_s(dotfile_path(fn),
                                      home_path(fn)) }
    end

    private
    def dotfile_path(filename)
      File.join(@dotfile_dir, filename)
    end

    def home_path(filename)
      File.join(@home_dir, filename)
    end

    def add_all_other_files
      return unless @symlinks.include?(:all_other_files)
      all_files = Dir.new(@dotfile_dir).entries
      other_files = all_files - %w(.. .)
      @symlinks = other_files
    end

    def add_to_group(group, files)
      if files.include?(:all_other_files) || group.include?(:all_other_files)
        [:all_other_files]
      else
        group + files
      end
    end
  end
end
