require "spec_helper"

describe "polka", :integrated_with_files do
  set_up_testdirs

  before { Polka.stub(:log) }

  it "provides a DSL to manage your dotfile setup" do
    setup_dotfiles %w(.onerc .tworc .threerc .nodotfile copyrc)
    setup_the_dotfile <<-EOF
      symlink :all_other_files
      symlink ".onerc", ".tworc"
      copy "copyrc"
      exclude ".nodotfile"
    EOF
    Cli.new.setup(home_dir, dotfile_dir)
    dir_entries = Dir.new(home_dir).entries
    dir_entries.should == %w(. .. .dotfile_dir .onerc .threerc .tworc copyrc)
    File.symlink?(File.join(home_dir, '.onerc')).should == true
    File.symlink?(File.join(home_dir, 'copyrc')).should == false
  end

  it "backs up existing files in your homedir" do
    Time.stub(:now) { Time.new(2222, 2, 2, 2, 22, 22) }
    setup_dotfiles %w(.onerc)
    setup_the_dotfile("symlink '.onerc'")
    FileUtils.touch(File.join(home_dir, '.onerc'))
    Cli.new.setup(home_dir, dotfile_dir)
    Dir.new(home_dir).entries.should == %w(. .. .dotfile_dir .onerc .polka_backup)
    Dir.new(File.join(home_dir, ".polka_backup", "2222-02-02_02:22:22")).entries.should == %w(. .. .onerc)
  end

  it "copys a parsed version of erb files" do
    setup_the_dotfile("copy '.inforc.erb'")
    setup_file_with_content("personal.yml", ".inforc:\n  name: peter venkman")
    setup_file_with_content(".inforc.erb", "hello <%= personal['name'] %>")
    Cli.new.setup(home_dir, dotfile_dir)
    File.open(File.join(home_dir, '.inforc')) { |f| f.read }.should == "hello peter venkman"
  end

  def setup_file_with_content(name, content)
    File.open(File.join(dotfile_dir, name), "w") { |f| f.write(content) }
  end

  def setup_the_dotfile(content)
    setup_file_with_content("Dotfile", content)
  end

  def setup_dotfiles(files)
    files.each { |fn| FileUtils.touch(File.join(dotfile_dir, fn)) }
  end
end
