# get
# returns the value
get "/:key" do
  value = git.pull params[:key]
  halt 404 unless value
  value
end

# create
# returns the new objects hash
post "/" do
  return unless params[:value]
  git.push params[:value]
end

# update
# returns the commit
put "/" do
  git.update params[:key], params[:value]
end
