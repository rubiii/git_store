require "spec_helper"
require "git/store/engine"

describe Git::Store::Engine do

  before(:all) { cd_test_dir }
  before(:each) { clean_git_repo }

  it "should have a global shortcut" do
    git.should == Git::Store::Engine
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

  it "should retrieve values for a given revision" do
    key = git.push "something"
    revision1 = git.update key, "else"
    revision2 = git.update key, "whatever"
    
    git.pull(revision1, key).should == "else"
    git.pull(revision2, key).should == "whatever"
  end

  it "should return a revision"

  it "should return nil if no revision exists"

end
