module HelperMethods

  def cd_test_dir
    test_dir = "/tmp/git_store"
    FileUtils.mkdir test_dir unless File.directory? test_dir
    FileUtils.cd File.expand_path(test_dir)
  end

  def clean_git_repo
    `rm -rf .git && git init`
  end

end
