require "spec_helper"

describe "polka", :integrated_with_files do
  set_up_testdirs

  it "provides a DSL to manage your dotfile setup" do
    setup_dotfiles %w(.onerc .tworc .threerc .nodotfile)
    setup_the_dotfile <<-EOF
      symlink :all_other_files
      symlink ".onerc", ".tworc"
      exclude ".nodotfile"
    EOF
    Cli.new.setup(home_dir, dotfile_dir)
    Dir.new(home_dir).entries.should == %w(. .. .dotfile_dir .onerc .tworc .threerc).sort
  end

  it "backs up existing files in your homedir" do
    Polka.stub(:log)
    Time.stub(:now) { Time.new(2222, 2, 2, 2, 22, 22) }
    setup_dotfiles %w(.onerc)
    setup_the_dotfile("symlink '.onerc'")
    FileUtils.touch(File.join(home_dir, '.onerc'))
    Cli.new.setup(home_dir, dotfile_dir)
    Dir.new(File.join(home_dir, ".polka_backup_2222-02-02_02:22:22")).entries.should == %w(. .. .onerc)
    Dir.new(home_dir).entries.should == %w(. .. .dotfile_dir .onerc .polka_backup_2222-02-02_02:22:22)
  end

  def setup_dotfiles(files)
    files.each { |fn| FileUtils.touch(File.join(dotfile_dir, fn)) }
  end

  def setup_the_dotfile(content)
    File.open(File.join(dotfile_dir, "Dotfile"), "w") { |f| f.write(content) }
  end
end
