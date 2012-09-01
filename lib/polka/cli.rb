module Polka
  class Cli < Thor
    desc "setup", "sets up your dotfiles according to the instructions in Dotfile"
    def setup(home_dir=nil, dotfile_dir=nil)
      dotfile_path = dotfile_dir ? File.join(dotfile_dir, "Dotfile") : "Dotfile"
      home_path = home_dir || ENV['HOME']
      dotfile_path = File.expand_path(dotfile_path)
      home_path = File.expand_path(home_path)
      File.open(dotfile_path) { |the_dotfile| Bootstrapper.from_dotfile(the_dotfile, home_path).setup }
    end
  end
end
