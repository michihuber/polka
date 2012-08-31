require_relative "../../lib/polka/bootstrapper.rb"

describe Polka::Bootstrapper do
  subject(:bs) { Polka::Bootstrapper.new('home', 'home/.polka') }

  describe "#setup" do
    it "symlinks the specified files" do
      bs.symlink('.testrc')
      FileUtils.should_receive(:ln_s).with("home/.polka/.testrc", "home/.testrc")
      bs.setup
    end

    context "if :all_other_files are used" do
      it "symlinks all files except excluded" do
        bs.exclude('.badrc')
        bs.symlink(:all_other_files)
        bs.exclude('.norc')
        dir = double(entries: %w(. .. .norc .badrc .testrc))
        Dir.stub(:new) { dir }
        FileUtils.should_receive(:ln_s).with("home/.polka/.testrc", "home/.testrc")
        bs.setup
      end
    end
  end
end

