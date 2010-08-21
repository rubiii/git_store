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

        alias_method :exist?, :pull

        def push(value)
          return if value.empty?
          
          key = hash_object value
          update_index :add, key
          commit key, write_tree
          key
        end

        def update(key, value)
          return if value.empty? || !exist?(key)
          
          new_key = hash_object value
          update_index :add, new_key, key
          commit key, write_tree
        end

        def remove(key)
          return unless exist? key
          
          update_index :remove, key
          commit key, write_tree
        end

        def revision(revision = nil)
          revision ||= Revision.head
          Revision.new revision if revision
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
          revision = args.first || Revision.head
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

        def commit(key, tree)
          cmd = "echo 'created #{key[0, 6]}' | git commit-tree #{tree}"
          cmd << " -p #{Revision.head}" if Revision.head
          Revision.save `#{cmd}`.chomp
        end

      end
    end
  end
end
