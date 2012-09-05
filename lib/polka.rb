require "yaml"
require "erb"

require "thor"
require "colorize"

require_relative "polka/cli"
require_relative "polka/bootstrapper"
require_relative "polka/dotfile"
require_relative "polka/dotfile_group"
require_relative "polka/operations/parsed_copying"

module Polka
  def self.config
    @config ||= {}
  end

  def self.config=(hash)
    @config = hash
  end

  def self.log(msg)
    $stdout.puts msg
  end

  def self.ask(question)
    $stdout.print question
    $stdout.flush
    $stdin.gets.chomp
  end
end
