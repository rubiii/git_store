require "git/store/core_ext"
require "git/store/revision"

module Git
  module Store
    module Engine
      class << self

        def pull(*args)
          value = show args
          return value unless value.empty?
        end

        def push(value)
          return if value.empty?
          
          key = hash_object value
          update_index :add, key
          commit key, write_tree
          key
        end

        def update(key, value)
          return if key.empty? || value.empty? || !pull(key)
          
          new_key = hash_object value
          update_index :add, new_key, key
          commit key, write_tree, Revision.latest
        end

        def remove(key)
          return if key.empty? || !pull(key)
          
          update_index :remove, key
          commit key, write_tree, Revision.latest
        end

        def revision(revision = nil)
          Revision.new revision
        end

        def type_of(key)
          `git cat-file -t #{key}`.chomp
        end

#        def parent(commit)
#          value = `git log #{commit} --parents -n 1 --skip=1 --pretty=format:%H`.chomp
#          return value unless value.empty?
#        end

#        def child(commit)
#          value = `git log #{commit} --children -n 1 --skip=1 --pretty=format:%H`.chomp
#          return value unless value.empty?
#        end

      private

        def show(args)
          key = args.pop
          revision = args.first || Revision.latest
          `git show #{revision}:#{key}`.chomp
        end

        def hash_object(value)
          `echo "#{value}" | git hash-object -w --stdin`.chomp
        end

        def update_index(*args)
          action = args.shift
          hash = args.shift
          file = args.first || hash
          
          `git update-index --#{action} --cacheinfo 100644 #{hash} #{file}`
        end

        def write_tree
          `git write-tree`.chomp
        end

        def commit(key, tree, parent = nil)
          cmd = "echo 'created #{key[0, 6]}' | git commit-tree #{tree}"
          cmd << " -p #{parent}" if parent
          Revision.save `#{cmd}`.chomp
        end

      end
    end
  end
end
