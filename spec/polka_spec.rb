require_relative "../lib/polka"
include Polka

describe "polka" do
  let(:home_dir) { "home_dir" }
  after { FileUtils.rm_rf(home_dir) }

  it "provides a DSL to manage your dotfile setup" do
    dotfile_dir = "home_dir/.dotfile_dir"
    FileUtils.mkdir(home_dir)
    FileUtils.mkdir(dotfile_dir)
    %w(.onerc .tworc .threerc .nodotfile).each { |fn| FileUtils.touch(File.join(dotfile_dir, fn)) }
    dotfile = <<-EOF
      symlink :all_other_files
      symlink ".onerc", ".tworc"
      exclude ".nodotfile"
    EOF
    File.open(File.join(dotfile_dir, "Dotfile"), "w") { |f| f.write(dotfile) }
    Cli.new.setup(home_dir, dotfile_dir)
    Dir.new(home_dir).entries.should == %w(. .. .dotfile_dir .onerc .tworc .threerc).sort
  end
end
