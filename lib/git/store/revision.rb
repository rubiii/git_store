require "git/store/tree"

module Git
  module Store
    class Revision

      def self.head
        head = `git show-ref master --hash`.chomp
        head unless head.empty?
      end

      def self.save(revision)
        `git update-ref refs/heads/master #{revision}`
        revision
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
