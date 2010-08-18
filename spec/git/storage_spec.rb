require "rspec"
require "git/store"

describe Git::Store do
  before { `rm -rf .git && git init` }

  it "should have a global shortcut" do
    git.should == Git::Store
  end

  it "should store and retrieve values" do
    key = git.push "something"
    git.pull(key).should == "something"
  end

  it "should return nil for non-existing keys" do
    git.pull("undefined").should be_nil
  end

  it "should update a value" do
    key = git.push "something"
    git.update key, "else"
    
    git.pull(key).should == "else"
  end

  it "should commit each change" do
    key = git.push "something"
    commit = git.update key, "else"
    
    git.type_of(commit).should == "commit"
  end

  it "should return the last commit" do
    key = git.push "something"
    commit = git.update key, "else"
    
    git.last_commit.should == commit
  end

end
