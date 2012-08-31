class Dotfile
  def initialize(path, home_path)
    @path = path
    @home_path = home_path
  end

  def setup
    FileUtils.ln_s(@path, @home_path)
  end

  def hash
    @path.hash
  end

  def equal?(other)
    hash == other.hash
  end
  alias :eql? equal?
end
