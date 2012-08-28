module Polka
  class Bootstrapper
    def initialize(home_dir)
      @home_dir = home_dir
    end

    def self.from_dotfile(dotfile, home_dir)
      bootstrapper = new(home_dir)
      bootstrapper.instance_eval(dotfile.read)
    end
  end
end
