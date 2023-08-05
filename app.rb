require "sinatra"
require "sinatra/reloader"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
end

get ("/umbrella") do
  erb(:umbrella)
end

get("/umbrella_result") do
  erb(:umbrella_result)
end
