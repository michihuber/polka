module Polka
  module Operations
    class ParsedCopying
      def self.call(file, dest)
        copier = new(file, dest)
        copier.run
      end

      def initialize(file, dest)
        @file = file
        @dest = dest
      end

      def run
        write(result)
      end

      private
      def result
        personal = context
        erb.result(binding)
      end

      def write(result)
        File.open(dest_without_erb, "w") { |f| f.write(result) }
      end

      def dest_without_erb
        @dest.gsub(/\.erb$/, "")
      end

      def context
        YAML.load_file(yaml_file)[context_name]
      end

      def yaml_file
        filename = Polka.config[:personal_file] || File.join(File.dirname(@file), "personal.yml")
        File.expand_path(filename)
      end

      def context_name
        File.basename(@file, ".erb")
      end

      def erb
        ERB.new(File.open(@file) { |f| f.read })
      end
    end
  end
end
