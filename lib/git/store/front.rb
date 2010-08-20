require "sinatra/base"
require "sinatra_more/markup_plugin"
require "sinatra_more/render_plugin"
require "rack-flash"
require "haml"

require "git/store/engine"

module Git
  module Store
    class Front < Sinatra::Base
      use Rack::MethodOverride
      use Rack::Flash

      register SinatraMore::MarkupPlugin
      register SinatraMore::RenderPlugin

      set :public, File.expand_path("../front/public", __FILE__)
      set :views, File.expand_path("../front/views", __FILE__)

      enable :sessions

      helpers do
        def flash_class
          type = flash[:alert] ? :alert : :notice
          "flash #{type}"
        end

        def highlight?(value)
          flash[:highlight] == value ? "notice" : ""
        end
      end

      # API

      get "/api" do
        @api = true
        haml :api
      end

      # get
      # returns the value
      get "/api/:key" do
        value = git.pull params[:key]
        halt 404 unless value
        value
      end

      # get
      # returns the value in a given revision
      get "/api/:revision/:key" do
        value = git.pull params[:revision], params[:key]
        halt 404 unless value
        value
      end

      # create
      # returns the new objects hash
      post "/api" do
        git.push params[:value]
      end

      # update
      # returns the commit
      put "/api/:key" do
        revision = git.update params[:key], params[:value]
        halt 404 unless revision
        revision
      end

      # delete
      # deletes a value
      delete "/api/:key" do
        git.remove params[:key]
      end

      # FRONT

      get "/" do
        @revision = git.revision
        haml :index
      end

      get "/:revision" do
        @revision = git.revision params[:revision]
        haml :index
      end

      post "/push" do
        key = git.push params[:value]
        
        flash[:notice] = "Thanks for the value Sir. Here's your key: #{key}"
        flash[:highlight] = params[:value]
        redirect "/"
      end

      put "/update" do
        if revision = git.update(params[:key], params[:value])
          flash[:notice] = "Great update Sir. The new revision is at: #{revision}"
          flash[:highlight] = params[:value]
        else
          flash[:alert] = "No can do. Please try something else Sir."
        end
        
        redirect "/"
      end

      delete "/remove" do
        if revision = git.remove(params[:key])
          flash[:notice] = "Sir, you removed: #{params[:key]}"
        else
          flash[:alert] = "I'm afraid I can't do that Sir."
        end
        
        redirect "/"
      end

    end
  end
end
