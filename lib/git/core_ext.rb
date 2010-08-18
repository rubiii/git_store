module Git
  module CoreExt

    module Object
      def git
        Git::Store
      end
    end

  end
end

Object.send :include, Git::CoreExt::Object
