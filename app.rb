require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
end

get ("/umbrella") do
  erb(:umbrella_form)
end

get("/umbrella_result") do
  @user_location = params.fetch("user_loc")

  gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + @user_location + "&key=" + ENV.fetch("GMAPS_KEY")

  raw_response = HTTP.get(gmaps_url).to_s

  parsed_response = JSON.parse(raw_response)

  results = parsed_response.fetch("results")

  first_results = results.at(0)
  
  geo = first_results.fetch("geometry")
  
  loc = geo.fetch("location")
  
  @latitude = loc.fetch("lat")
  @longitude = loc.fetch("lng")

  pirate_weather_url = "https://api.pirateweather.net/forecast/" + ENV.fetch("PIRATE_WEATHER_KEY") + "/#{@latitude},#{@longitude}"

  response = HTTP.get(pirate_weather_url).to_s
  
  parsed_respo = JSON.parse(response)

  currently = parsed_respo.fetch("currently")

  @temp = currently.fetch("temperature").to_s
  @summary = currently.fetch("summary").to_s

  hourly = parsed_respo.fetch("hourly")

  data = hourly.fetch("data")

  next_hour = data.at(0)

  @precip_prob = next_hour.fetch("precipProbability")

  erb(:umbrella_result)
end
