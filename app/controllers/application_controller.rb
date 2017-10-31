require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
  #  set :public_folder, 'public'
  #  set :views, 'app/views'
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    erb :'/users/create_user'
  end

  post '/signup' do
    user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
    if user.username != "" && user.email != "" && user.password != "" && user.save
      redirect "/tweets"
    else
      redirect "/failure"
    end
  end

  get '/login' do

  end

  post '/login' do

  end

end
