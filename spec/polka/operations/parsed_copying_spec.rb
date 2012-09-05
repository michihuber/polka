require "spec_helper"

describe Polka::Operations::ParsedCopying, :integrated_with_files do
  subject(:copier) { Polka::Operations::ParsedCopying }
  let(:input_file) { File.join(dotfile_dir, "to_be_parsed.erb") }
  let(:output_file) { File.join(home_dir, "parsable") }
  let(:personal_file) { File.join(dotfile_dir, "personal.yml") }
  set_up_testdirs

  before do
    File.open(input_file, "w") { |f| f.write("hello <%= personal['name'] %>") }
  end

  def write_personal_file(filename)
    File.open(filename, "w") { |f| f.write("to_be_parsed:\n  name: ray stanz") }
  end

  def parsed_content
    File.open(output_file) { |f| f.read }
  end

  it "parses the erb file and copys the result without the extension" do
    write_personal_file(personal_file)

    copier.call(input_file, output_file + ".erb")
    parsed_content.should == "hello ray stanz"
  end

  it "prompts for input if a personal reference is missing from personal.yml" do
    write_personal_file(personal_file)

    File.open(input_file, "w") { |f| f.write("hello <%= personal['not_name'] %>") }
    Polka.stub(:ask) { "johnny" }
    copier.call(input_file, output_file)
    parsed_content.should == "hello johnny"
  end

  it "uses the personal.yml provided in the config" do
    another_dir = File.join(dotfile_dir, "another_dir")
    personal_file = File.join(another_dir, "polka_personal.yml")
    FileUtils.mkdir(another_dir)
    write_personal_file(personal_file)

    Polka.stub(:config) { { personal_file: another_dir + "/polka_personal.yml" } }

    copier.call(input_file, output_file)
    parsed_content.should == "hello ray stanz"
  end

  it "doesn't produce errors if personal file is missing" do
    Polka.stub(:config) { { personal_file: "does_not_exist" } }
    Polka.stub(:ask) { "what" }
    Polka.stub(:log)
    expect { copier.call(input_file, output_file) }.to_not raise_error
  end
end
