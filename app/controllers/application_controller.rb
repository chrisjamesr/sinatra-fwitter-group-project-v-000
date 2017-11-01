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
    new_tweet = Tweet.create(params[:content])
    new_tweet.user = user
    new_tweet.save
    erb :'/tweets/tweets'
  end

  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    erb :'/tweets/show_tweet'
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find(params[:id])
    if @tweet.user_id == session[:user_id]
      erb :'/tweets/edit_tweet'
    else
      redirect '/tweets'
    end
  end

  post 'tweets/:id' do
    @tweet = Tweet.find(params[:id])
    erb :'/tweets/show_tweet'
  end

  post 'tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    @tweet.delete
  end

  get '/logout' do
    if !!session[:id]
      session.clear
      redirect "/login"
    else
      redirect "/"
    end
  end

    helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end
  

end
