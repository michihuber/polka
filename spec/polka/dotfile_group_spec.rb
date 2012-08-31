require_relative "../../lib/polka/dotfile_group.rb"

describe DotfileGroup do
  subject(:group) { DotfileGroup.new }

  describe "#add" do
    it "adds dotfiles" do
      group.add([1,2,3])
      group.files.should == [1,2,3]
    end
  end

  describe "#add_all_other_files" do
    it "adds all other files to the group" do
      DotfileGroup.all_files = [1, 2, 3]
      other_group = DotfileGroup.new
      group.add([1])
      group.add_all_other_files
      other_group.add([3])
      group.files.sort.should == [1,2]
    end
  end
end
