class AllOtherFilesAlreadyAdded < StandardError; end
class FileAlreadyAddedError < StandardError; end

class DotfileGroup
  @@all_files = []
  @@grouped_files = []
  @@all_other_files_added = false

  def self.all_files=(files)
    @@all_files = files
    @@grouped_files = []
    @@all_other_files_added = false
  end

  def self.remaining_files
    @@all_files - @@grouped_files
  end

  def initialize(operation=nil, setup_msg=nil)
    @operation = operation
    @setup_message = setup_msg
    @files = []
    @all_other_files = false
  end

  def add(new_files)
    raise FileAlreadyAddedError if new_files.any? { |f| @@grouped_files.include?(f) }
    @@grouped_files += new_files
    @files += new_files
  end

  def add_all_other_files
    raise AllOtherFilesAlreadyAdded if @@all_other_files_added
    @@all_other_files_added = true
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
    Polka.log @setup_message.light_blue unless files.empty?
    files.each { |f| f.setup(@operation) }
  end
end
