class UsersController < ApplicationController
  post '/signup' do
    user = User.create(username: params[:username], email: params[:email], password: params[:password])

    if user.valid?
      session[:id] = user.id
      redirect '/tweets'
    else
      redirect '/signup'
    end
  end

  get '/login' do
    if !session[:id].nil?
      redirect '/tweets'
    end

    erb :'users/login'
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.valid?
      user.authenticate(params[:password])
      session[:id] = user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

  get '/users/:username' do
    @user = User.find_by username: params[:username]

    erb :'users/show'
  end
end
