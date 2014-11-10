require './song.rb'
require 'sinatra'
require 'slim'
require 'sass'
#require 'sinatra/reloader' if development?


configure :production do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure do
  enable :sessions
  set :username, 'isaac'
  set :password, 'agutey'
end

get('/styles.css'){scss :styles}

get '/' do
  slim :login
end

get '/home' do
  halt(401,'Not Authorized') unless session[:admin]
  slim :home
end

get '/about' do
  halt(401,'Not Authorized') unless session[:admin]
  slim :about
end
get '/contact' do
  halt(401,'Not Authorized') unless session[:admin]
  slim :contact
end

get '/not_found' do
  halt(401,'Not Authorized') unless session[:admin]
  slim :not_found
end

get '/fake-error' do
  halt(401,'Not Authorized') unless session[:admin]
  status 500
  'There’s nothing wrong, really :P'
end

# get '/environment' do
#   if development?
#     "development"
#   elsif production?
#     "production"
#   elsif test?
#     "test"
#   else
#     "who cares about the environment anyway"
#   end
# end

get '/set/:name' do
  halt(401,'Not Authorized') unless session[:admin]
  session[:name]=params[:name]
end

get '/get/hello' do
  halt(401,'Not Authorized') unless session[:admin]
  "Hello #{session[:name]} "
end

post '/login' do
  if params[:username]==settings.username && params[:password]==settings.password
    session[:admin]=true
    redirect to('/songs')
  else
    slim :login
  end
end

get '/logout' do
  session.clear
  redirect to('/login')
end

############################################


get '/songs' do
  halt(401,'Not Authorized') unless session[:admin]
  @songs=Song.all
  slim :songs
end

get '/songs/new' do
  @song = Song.new
  slim :new_song
end

get '/songs/:id' do
  @song = Song.get(params[:id])
  slim :show_song
end

post '/songs' do
  song=Song.create(params[:song])
  redirect to("/songs/#{song.id}")

end

get '/songs/:id/edit' do
  @song = Song.get(params[:id])
  slim :edit_song
end

put '/songs/:id' do
  song=Song.get(params[:id])
  song.update(params[:song])
  redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
  Song.get(params[:id]).destroy
  redirect to('/songs')
end