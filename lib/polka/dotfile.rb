class FileNotPresentError < StandardError; end

class Dotfile
  def initialize(path, home_path)
    raise FileNotPresentError, "Could not find file at #{path}." unless File.exists?(path)
    @path = path
    @home_path = home_path
  end

  def setup
    backup if File.exists?(@home_path)
    yield @path, @home_path
  end

  def backup
    Polka.log "Backing up: #{@home_path} => #{backup_dir}"
    FileUtils.mkdir(backup_dir) unless File.exists?(backup_dir)
    FileUtils.mv(@home_path, backup_dir)
  end

  def hash
    @path.hash
  end

  def equal?(other)
    hash == other.hash
  end
  alias :eql? equal?

  def self.backup_dir(home_path)
    dir = ".polka_backup_" + Time.now.strftime("%F_%T")
    @@backup_dir ||= File.join(home_path, dir)
  end

  private
  def backup_dir
    Dotfile.backup_dir(File.dirname(@home_path))
  end
end
