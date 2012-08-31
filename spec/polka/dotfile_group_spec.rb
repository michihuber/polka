require_relative "../../lib/polka/dotfile_group.rb"

describe DotfileGroup do
  subject(:group) { DotfileGroup.new }
  1.upto(3) { |n| fn = "file#{n}".to_sym; let(fn) { double(fn) } }

  before do
    DotfileGroup.all_files = [file1, file2, file3]
  end

  describe "#add" do
    it "adds dotfiles" do
      group.add([file1, file2])
      group.files.should == [file1, file2]
    end

    it "can only add each file once" do
      group.add([file1])
      expect { group.add([file1]) }.to raise_error(FileAlreadyAddedError)
    end
  end

  describe "#add_all_other_files" do
    let(:other_group) { DotfileGroup.new }

    it "adds all other files to the group" do
      group.add([file1])
      group.add_all_other_files
      other_group.add([file3])
      group.files.should == [file2, file1]
    end

    it "can only be called once" do
      group.add_all_other_files
      expect {other_group.add_all_other_files }.to raise_error(AllOtherFilesAlreadyAdded)
    end
  end
end
