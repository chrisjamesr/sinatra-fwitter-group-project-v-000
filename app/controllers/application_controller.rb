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
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/signup"
    end
  end

  get '/login' do
    if !session[:user_id]
    erb :'/users/login'
    else
    redirect "/tweets"
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/login"
    end
  end

  get '/tweets' do
    if !!session[:user_id]
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect "/login"
    end
  end

  get '/tweets/new' do
    if !!session[:user_id]
      erb :'tweets/create_tweet'
    else
      redirect "/login"
    end
  end

  post '/tweets' do
    user = User.find_by_id(session[:user_id])
    new_tweet = params[:content]
    new_tweet.user = user
    new_tweet.save
  end

end
