require "git/core_ext"

module Git
  module Store
    class << self

      LastCommit = ".last_commit"

      def pull(key)
        value = show key
        return value unless value.empty?
      end

      def push(value)
        key = hash_object value
        update_index key
        commit key, write_tree
        key
      end

      def update(key, value)
        new_key = hash_object value
        update_index new_key, key
        commit key, write_tree, last_commit
      end

      def type_of(key)
        `git cat-file -t #{key}`.chomp
      end

      def last_commit
        File.read LastCommit
      end

    private

      def show(key)
        value = `git show #{last_commit}:#{key}`.chomp
        #value.empty? ? `git cat-file -p #{key}`.chomp : value
      end

      def hash_object(value)
        `echo "#{value}" | git hash-object -w --stdin`.chomp
      end

      def update_index(hash, file = nil)
        file ||= hash
        `git update-index --add --cacheinfo 100644 #{hash} #{file}`
      end

      def write_tree
        `git write-tree`.chomp
      end

      def commit(key, tree, parent = nil)
        cmd = "echo 'created #{key[0, 6]}' | git commit-tree #{tree}"
        cmd << " -p #{parent}" if parent
        store_last_commit `#{cmd}`.chomp
      end

      def store_last_commit(commit)
        File.open(LastCommit, "w+") { |file| file.write commit }
        commit
      end

    end
  end
end
