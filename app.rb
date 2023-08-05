require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  erb(:homepage)
end

get("/umbrella") do
 
  #HELP ADDING THIS TO THE UMBRELLA_FORM
  # <p>You last searched for:</p>

  # <ul>
  #   <li><%= cookies["last_loc"] %></li>
  #   <li><%= cookies["last_lat"] %></li>
  #   <li><%= cookies["last_lng"] %></li>
  # </ul>

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

  @precip_prob = next_hour.fetch("precipProbability").to_s

=begin -- CODE FOR UMBRELLA_RESULT IS NOT WORKING
    <% if @precip_prob >= 50 %>
        You will probably need an umbrella.
      <% else %>
         You probably won't need an umbrella.
      <% end %>
=end

  #cookies["last_loc"] = @user_location
  #cookies["last_lat"] = @latitude
  #cookies["last_lng"] = @longitude

  erb(:umbrella_result)
end

get("/message") do
  erb(:message_form)
end

get("/message_result") do
  @user_message = params.fetch("user_message")

  gpt_url = "https://chatwithgpt.netlify.app/" + @user_message + "&key=" + ENV.fetch("GPT4_KEY")
  
  erb(:message_result)
end
