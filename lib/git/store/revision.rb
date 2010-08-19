require "git/store/tree"

module Git
  module Store
    class Revision

      LatestRevision = ".latest_revision"

      def self.latest
        raise "Ok, so this is a little embarrassing. I need to ask you to create an empty #{LatestRevision} file " +
          "in your current directoy and then try again. _why?" unless File.exist? LatestRevision
        File.read LatestRevision unless File.zero? LatestRevision
      end

      def self.save(revision)
        File.open(LatestRevision, "w+") { |file| file.write revision }
        revision
      end

      def self.new(revision = nil)
        revision ||= latest
        super revision if revision
      end

      def initialize(revision)
        @sha = revision
      end

      attr_reader :sha

      def parent
      end

      def child
      end

      def tree
        Tree.new sha
      end

    end
  end
end
