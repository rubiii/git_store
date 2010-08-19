require "git/store/leaf"

module Git
  module Store
    class Tree

      def initialize(revision)
        @revision, @sha = revision, tree_for(revision)
      end

      attr_reader :revision, :sha

      def empty?
        leafs.empty?
      end

      def each
        leafs.each { |leaf| yield leaf }
      end

    private

      def tree_for(revision)
        `git log #{revision} --pretty=format:'%T' -n 1`.chomp
      end

      def leafs
        @leafs ||= object.inject([]) { |memo, line| memo << Leaf.new(revision, line.strip.split(" ")) }.sort
      end

      def object
        `git cat-file -p #{sha}`.chomp
      end

    end
  end
end
