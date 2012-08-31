require "spec_helper"

describe Polka::Operations::ParsedCopying, :integrated_with_files do
  set_up_testdirs

  it "parses the erb file and copys the result without the extension" do
    File.open(File.join(dotfile_dir, "blah.erb"), "w") { |f| f.write("hello <%= personal['name'] %>") }
    File.open(File.join(dotfile_dir, "personal.yml"), "w") { |f| f.write("blah:\n  name: ray stanz") }

    Polka::Operations::ParsedCopying.call(File.join(dotfile_dir, "blah.erb"), File.join(home_dir, "foo.erb"))
    File.open(File.join(home_dir, "foo")) { |f| f.read }.should == "hello ray stanz"
  end
end
