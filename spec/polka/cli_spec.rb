require "thor"
require_relative "../../lib/polka/cli.rb"
class Polka::Bootstrapper; end

describe Polka::Cli do
  describe "#setup" do
    let(:the_dotfile) { double }
    let(:bootstrapper) { double(:bootstrapper, setup: "works") }

    it "initializes a bootstrapper with the Dotfile (and the target dir)" do
      File.stub(:open).and_yield(the_dotfile)
      Polka::Bootstrapper.should_receive(:from_dotfile).with(the_dotfile, File.expand_path(ENV['HOME'])).and_return(bootstrapper)
      bootstrapper.setup.should == "works"

      Polka::Cli.new.setup
    end

    it "accepts home_dir and dotfile_dir as optional arguments" do
      File.stub(:open).and_yield(the_dotfile)
      Polka::Bootstrapper.should_receive(:from_dotfile).with(the_dotfile, File.expand_path("home")).and_return(bootstrapper)
      bootstrapper.setup.should == "works"

      Polka::Cli.new.setup("home", "home/.polka")
    end
  end
end
