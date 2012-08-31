require "thor"
require "yaml"
require "erb"

require_relative "polka/cli"
require_relative "polka/bootstrapper"

require_relative "polka/dotfile"
require_relative "polka/dotfile_group"

require_relative "polka/operations/parsed_copying"

module Polka
  def self.log(msg)
    puts msg
  end
end
