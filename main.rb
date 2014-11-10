require './song.rb'
require 'sinatra'
require 'slim'
require 'sass'
#require 'sinatra/reloader' if development?

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