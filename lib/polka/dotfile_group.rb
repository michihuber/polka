class DotfileGroup
  @@all_files = []
  @@grouped_files = []
  def self.all_files=(files)
    @@all_files = files
    @@grouped_files = []
  end

  def self.remaining_files
    @@all_files - @@grouped_files
  end

  def initialize
    @files = []
    @all_other_files = false
  end

  def add(new_files)
    @@grouped_files += new_files
    @files += new_files
  end

  def add_all_other_files
    @all_other_files = true
  end

  def files
    if @all_other_files
      DotfileGroup.remaining_files + @files
    else
      @files
    end
  end

  def setup
    files.each(&:setup)
  end
end
