module Puncsig

  class FileReport
    attr_reader :filename

    def initialize(filename, method_sigs)
      @filename = filename
      @method_sigs = method_sigs
    end

    def method_names
      @method_sigs.keys
    end

    # Not sure this is how it'll end up...
    def method_sigs
      @method_sigs
    end
  end

  class Parser
    def parse(filename)
      src = src(filename)
      methods = methods(src)
      method_sigs = Hash[*methods.map { |name, src| [name, puncsig(src)] }.flatten]
      FileReport.new(filename, method_sigs)
    end

    private

    def src(path)
      File.read(path).gsub(/^\s*#.*$/, '')
    end

    # Note: for models, this ignores stuff like named_scopes, etc. That's ok for now, and maybe ok for later.
    def methods(src)

      # TODO This leaves out methods like [], <<, etc...maybe just check for first non-space?
      method_sigs = /def\s+[a-z_!?.]+/
      method_names = src.scan(method_sigs).map { |sig| sig.sub(/^def /, '') }

      bodies = src.split(method_sigs)[1..-1]  # strip off first chunk, the class beginning

      method_names.zip(bodies)
    end

    def puncsig(src)
      src.gsub(/[a-z0-9'"_\s]/i, '')
    end

  end

  class Report

    def initialize(*filename_methods)
      @filenames = filename_methods.flatten
    end

    def run
      parser = Parser.new

      @filenames.each do |filename|

        file_report = parser.parse(filename)
        len = file_report.method_names.map(&:size).max

        puts file_report.filename
        file_report.method_sigs.sort_by { |n, s| -s.size }.each do |name, sig|
          print "#{name}:".ljust(len + 3)
          puts sig
        end
        puts
      end
    end
  end
end

require 'puncsig/railtie' if defined?(Rails)
