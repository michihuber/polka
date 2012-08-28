module Polka
  class Cli
    def setup(home_dir=nil, dotfile_dir=nil)
      dotfile_path = dotfile_dir ? File.join(dotfile_dir, "Dotfile") : "Dotfile"
      home_path = home_dir || ENV['HOME']
      File.open(dotfile_path) { |the_dotfile| Bootstrapper.from_dotfile(the_dotfile, home_path).setup }
    end
  end
end
