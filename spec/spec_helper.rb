require_relative "../lib/polka"
include Polka

module FileSetupHelper
  def set_up_testdirs
    let(:home_dir) { "home_dir" }
    let(:dotfile_dir) { "home_dir/.dotfile_dir" }

    before do
      FileUtils.mkdir(home_dir)
      FileUtils.mkdir(dotfile_dir)
    end

    after do
      FileUtils.rm_rf(home_dir)
    end
  end
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.extend FileSetupHelper, :integrated_with_files
end
