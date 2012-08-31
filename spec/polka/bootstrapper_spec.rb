require_relative "../../lib/polka/bootstrapper.rb"
class Dotfile; end
class DotfileGroup; end

describe Polka::Bootstrapper do
  subject(:bs) { Polka::Bootstrapper.new('home', 'home/.polka') }
  let(:symlink_group) { double(:symlinks) }
  let(:excluded_group) { double(:excluded) }

  before do
    Dir.stub(:new) { double(entries: %w(. .. blah)) }
    blah_dotfile = double
    the_dotfile = double(:Dotfile)
    Dotfile.should_receive(:new).with('home/.polka/blah', 'home/blah').and_return(blah_dotfile)
    Dotfile.should_receive(:new).with('home/.polka/Dotfile', 'home/Dotfile').and_return(the_dotfile)
    excluded_group.should_receive(:add).with([the_dotfile])
    DotfileGroup.should_receive(:all_files=).with([blah_dotfile])
    DotfileGroup.stub(:new).and_return(symlink_group, excluded_group)
  end

  describe "#setup" do
    it "sets up the symlink group" do
      symlink_group.should_receive(:setup)
      bs.setup
    end
  end

  describe "#symlink, #exclude" do
    describe "addings files without options" do
      let(:hello_dotfile) { double(:hello_dotfile) }
      before { Dotfile.stub(:new) { hello_dotfile } }
      it "adds to the symlink group" do
        symlink_group.should_receive(:add).with([hello_dotfile])
        bs.symlink "hello"
      end

      it "adds to the exclude group" do
        excluded_group.should_receive(:add).with([hello_dotfile])
        bs.exclude "hello"
      end
    end

    describe ":all other files" do
      it "adds :all_other_files" do
        symlink_group.should_receive(:add_all_other_files)
        bs.symlink :all_other_files
      end

      it "adds :all_other_files" do
        excluded_group.should_receive(:add_all_other_files)
        bs.exclude :all_other_files
      end
    end

    it "adds file with home_dir_path if specified" do
      alias_dotfile = double(:alias_dotfile)
      Dotfile.should_receive(:new).with("home/.polka/.testrc", "home/.onerc").and_return(alias_dotfile)
      symlink_group.should_receive(:add).with([alias_dotfile])
      bs.symlink(".testrc", as: ".onerc")
    end
  end
end

