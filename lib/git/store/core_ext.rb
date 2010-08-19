module Git
  module Store
    module CoreExt

      module Object
        def git
          Git::Store::Engine
        end
      end

    end
  end
end

Object.send :include, Git::Store::CoreExt::Object
