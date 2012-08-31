require_relative "../../lib/polka/bootstrapper.rb"
require_relative "../../lib/polka/dotfile.rb"
require_relative "../../lib/polka/dotfile_group.rb"

describe Polka::Bootstrapper do
  subject(:bs) { Polka::Bootstrapper.new('home', 'home/.polka') }

  describe "#setup" do
    let(:dir) { double(entries: %w(. .. .norc .badrc .onerc .tworc .threerc)) }
    before do
      Dir.stub(:new) { dir }
    end

    it "symlinks the specified files" do
      bs.symlink('.onerc')
      FileUtils.should_receive(:ln_s).with("home/.polka/.onerc", "home/.onerc")
      bs.setup
    end

    context "if :all_other_files are used" do
      it "symlinks all files except excluded" do
        bs.exclude('.badrc')
        bs.symlink('.onerc')
        bs.symlink(:all_other_files)
        bs.symlink('.threerc')
        bs.exclude('.norc')
        FileUtils.should_receive(:ln_s).with("home/.polka/.onerc", "home/.onerc")
        FileUtils.should_receive(:ln_s).with("home/.polka/.tworc", "home/.tworc")
        FileUtils.should_receive(:ln_s).with("home/.polka/.threerc", "home/.threerc")
        bs.setup
      end
    end
  end
end

