module Git
  module Store
    class Leaf

      def initialize(revision, values)
        @revision = revision
        @filemode, @type, @sha, @file = values
      end

      attr_reader :revision, :filemode, :type, :sha, :file

      def <=>(other)
        other.value > value ? -1 : 1
      end

      def value
        @value ||= git.pull revision, file
      end

    end
  end
end
