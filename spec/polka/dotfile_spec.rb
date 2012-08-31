require_relative "../../lib/polka/dotfile.rb"

describe Dotfile do
  describe "#setup" do
    it "creates a symlink to itself in the home dir" do
      df = Dotfile.new("home_dir/.polka/.testrc", "home_dir/.testrc")
      FileUtils.should_receive(:ln_s).with("home_dir/.polka/.testrc", "home_dir/.testrc")
      df.setup
    end
  end

  describe "equality" do
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
