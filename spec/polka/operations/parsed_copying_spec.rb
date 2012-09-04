require "spec_helper"

describe Polka::Operations::ParsedCopying, :integrated_with_files do
  set_up_testdirs

  before do
    File.open(File.join(dotfile_dir, "blah.erb"), "w") { |f| f.write("hello <%= personal['name'] %>") }
  end

  def write_personal_file(filename)
    File.open(filename, "w") { |f| f.write("blah:\n  name: ray stanz") }
  end

  it "parses the erb file and copys the result without the extension" do
    personal_file = File.join(dotfile_dir, "personal.yml")
    write_personal_file(personal_file)

    Polka::Operations::ParsedCopying.call(File.join(dotfile_dir, "blah.erb"), File.join(home_dir, "foo.erb"))
    File.open(File.join(home_dir, "foo")) { |f| f.read }.should == "hello ray stanz"
  end

  it "uses the personal.yml provided in the config" do
    another_dir = File.join(dotfile_dir, "another_dir")
    personal_file = File.join(another_dir, "polka_personal.yml")
    FileUtils.mkdir(another_dir)
    write_personal_file(personal_file)

    Polka.stub(:config) { { personal_file: another_dir + "/polka_personal.yml" } }

    Polka::Operations::ParsedCopying.call(File.join(dotfile_dir, "blah.erb"), File.join(home_dir, "foo.erb"))
    File.open(File.join(home_dir, "foo")) { |f| f.read }.should == "hello ray stanz"
  end
end
