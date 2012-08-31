require "spec_helper"

describe Dotfile do
  describe "#setup", :integrated_with_files do
    set_up_testdirs

    def home_path(filename)
      File.join(home_dir, filename)
    end

    def dotfile_path(filename)
      File.join(dotfile_dir, filename)
    end

    it "raises if dotfile does not exist" do
      expect { Dotfile.new(dotfile_path('.testrc'), "irrelevant") }.to raise_error(FileNotPresentError)
    end

    it "yields to a given operation" do
      FileUtils.touch(dotfile_path('.testrc'))
      df = Dotfile.new(dotfile_path('.testrc'), home_path('.testrc'))
      df.setup { |dest, src| FileUtils.ln_s(dest, src) }
      Dir.new(home_dir).entries.should == %w(. .. .dotfile_dir .testrc)
    end

    context "the homedir already contains the file" do
      it "backs up into a backup dir" do
        Time.stub(:now) { Time.new(2222, 2, 2, 2, 22, 22) }
        FileUtils.touch(home_path('.testrc'))
        FileUtils.touch(dotfile_path('.testrc'))
        df = Dotfile.new(dotfile_path('.testrc'), home_path('.testrc'))
        Polka.stub(:log)
        df.setup { |a, b| FileUtils.cp(a, b) }
        Dir.new(home_dir).entries.should == %w(. .. .dotfile_dir .polka_backup_2222-02-02_02:22:22 .testrc)
      end
    end
  end

  describe "equality" do
    before { File.stub(:exists?) { true } }

    it "regards dotfiles as equal if they share the same dotfile dir path" do
      df1 = Dotfile.new("home/df1", "blah")
      df2 = Dotfile.new("home/df1", "foo")
      df1.equal?(df2).should == true
    end

    it "substracts equal dotfiles in array substraction" do
      df1 = Dotfile.new("home/df1", "blah")
      df2 = Dotfile.new("home/df1", "foo")
      ([df1] - [df2]).should == []
    end
  end
end
