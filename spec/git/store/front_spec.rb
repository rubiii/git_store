require "spec_helper"
require "rack/test"

require "git/store/front"

# setup test environment
Git::Store::Front.set :environment, :test
Git::Store::Front.set :run, false
Git::Store::Front.set :raise_errors, true
Git::Store::Front.set :logging, false

describe Git::Store::Front do
  include Rack::Test::Methods

  before(:all) do
    cd_test_dir
    clean_git_repo
    
    # setup test data
    @chunky = git.push "chunky"
    @bacon = git.push "bacon"
    @first_revision = git.update @chunky, "hackety"
    @second_revision = git.update @chunky, "hack"
  end

  def app
    Git::Store::Front
  end

  context "GET /api/:key" do
    it "should return a value" do
      get "/api/#{@chunky}"
      last_response.body.should == "hack"
    end

    it "should return 404 in case a value doesn't exist" do
      get "/api/undefined"
      last_response.status.should == 404
    end
  end

  context "GET /api/:revision/:key" do
    it "should return a value for a given revision" do
      get "/api/#{@first_revision}/#{@chunky}"
      last_response.body.should == "hackety"
    end
    
    it "should return 404 in case a value doesn't exist" do
      get "/api/undefined/undefined"
      last_response.status.should == 404
    end
  end

  context "POST /api" do
    it "should create a new value and return its hash" do
      post "/api", :value => "whyday"
      last_response.body.should == "63996f2ada7cfff6d0943ce0fd33460e159cfd10"
    end
  end

  context "PUT /api/:key" do
    it "should update a value and return the new revision" do
      post "/api", :value => "trady"
      
      put "/api/#{last_response.body}", :value => "blix"
      git.commit?(last_response.body).should be_true
    end
  end

  context "DELETE /api/:key" do
    it "should delete a value and return the new revision" do
      post "/api", :value => "_why"
      
      delete "/api/#{last_response.body}"
      git.commit?(last_response.body).should be_true
    end
  end

  context "/" do
    it "should return something" do
      get "/"
      last_response.should be_ok
    end
  end

end
