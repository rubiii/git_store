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
    
    git.commit?(commit).should be_true
  end

  it "should retrieve values for a given revision" do
    key = git.push "something"
    first_revision = git.update key, "else"
    second_revision = git.update key, "whatever"
    
    git.pull(first_revision, key).should == "else"
    git.pull(second_revision, key).should == "whatever"
  end

  describe ".revision" do
    it "should return a revision" do
      key = git.push "something"
      first_revision = git.update key, "else"
      second_revision = git.update key, "whatever"
      
      revision = git.revision first_revision
      
      revision.should be_a(Git::Store::Revision)
      revision.sha.should == first_revision
    end

    it "should default to return the HEAD revision" do
      key = git.push "something"
      first_revision = git.update key, "else"
      second_revision = git.update key, "whatever"
      
      git.revision.sha.should == second_revision
    end

    it "should return +nil+ in case a given revision does not exist" do
      git.revision("undefined").should be_nil
    end
  end

end
