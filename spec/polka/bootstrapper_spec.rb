require_relative "../../lib/polka/bootstrapper.rb"

describe Polka::Bootstrapper do
  subject(:bs) { Polka::Bootstrapper.new('home', 'home/.polka') }

  describe "#symlink" do
    it "adds the files to the symlink setup group" do
      bs.symlink('.testrc', '.anotherrc')
      bs.symlinks.should == ['.testrc',
                             '.anotherrc']
    end

    context ":all_other_files" do
      it "only adds :all_other_files" do
        bs.symlink('.testrc')
        bs.symlink(:all_other_files, '.anotherrc')
        bs.symlink('.yetanotherrc')
        bs.symlinks.should == [:all_other_files]
      end
    end
  end

  describe "#exclude" do
    it "adds the files to the symlink setup group" do
      bs.exclude('.testrc', '.anotherrc')
      bs.excluded.should == ['.testrc',
                             '.anotherrc']
    end

    context ":all_other_files" do
      it "only add:all_other_files" do
        bs.exclude('.testrc')
        bs.exclude(:all_other_files, '.anotherrc')
        bs.exclude('.yetanotherrc')
        bs.excluded.should == [:all_other_files]
      end
    end
  end
end

