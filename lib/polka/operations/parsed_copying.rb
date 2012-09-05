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
        context = Hash.new do |_, k|
          Polka.ask "    Please provide personal['#{k}'] for #{context_name}: "
        end

        if File.exists?(yaml_file)
          yaml_hash = YAML.load_file(yaml_file)[context_name]
          context = context.merge(yaml_hash) if yaml_hash
        end

        return context
      end

      def yaml_file
        filename = Polka.config[:personal_file] || File.join(File.dirname(@file), "personal.yml")
        filename = File.expand_path(filename)
        Polka.log("Warning! ".yellow + "Could not find personal file at #{filename}") unless File.exists?(filename)

        filename
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
