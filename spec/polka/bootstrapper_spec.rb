require_relative "../../lib/polka/bootstrapper.rb"
require_relative "../../lib/polka/dotfile.rb"

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
        bs.symlink('.onerc')
        bs.symlink(:all_other_files)
        bs.symlink('.threerc')
        bs.exclude('.norc')
        dir = double(entries: %w(. .. .norc .badrc .onerc .tworc .threerc))
        Dir.stub(:new) { dir }
        FileUtils.should_receive(:ln_s).with("home/.polka/.onerc", "home/.onerc")
        FileUtils.should_receive(:ln_s).with("home/.polka/.tworc", "home/.tworc")
        FileUtils.should_receive(:ln_s).with("home/.polka/.threerc", "home/.threerc")
        bs.setup
      end
    end
  end
end

