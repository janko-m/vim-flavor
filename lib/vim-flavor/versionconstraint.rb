module Vim
  module Flavor
    class VersionConstraint
      attr_reader :base_version

      # Specifies how to choose a suitable version according to base_version.
      attr_reader :qualifier

      def initialize(s)
        @base_version, @qualifier = self.class.parse(s)
      end

      def to_s()
        "#{qualifier} #{base_version}"
      end

      def ==(other)
        self.base_version == other.base_version &&
          self.qualifier == other.qualifier
      end

      def self.parse(s)
        m = /^\s*(>=|~>|branch:)\s+(\S+)\s*$/.match(s)
        if m
          if m[1] == 'branch:'
            [Version.create(branch: m[2]), m[1]]
          else
            [Version.create(m[2]), m[1]]
          end
        else
          raise "Invalid version constraint: #{s.inspect}"
        end
      end

      def compatible?(version)
        if qualifier == '~>'
          self.base_version.bump() > version and version >= self.base_version
        elsif qualifier == '>='
          version >= self.base_version
        elsif qualifier == 'branch:'
          version.branch == self.base_version.branch
        else
          raise NotImplementedError
        end
      end

      def find_the_best_version(versions)
        versions.
          select {|v| compatible?(v)}.
          max() or raise 'There is no valid version'
      end
    end
  end
end
