class TweetsController < ApplicationController
  get '/tweets' do
    if session[:id].nil?
      redirect '/login'
    end

    @tweets = Tweet.all
    @user = User.find session[:id]

    erb :'tweets/tweets'
  end

  get '/tweets/new' do
    if is_logged_in?
      erb :'tweets/new'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    @tweet = Tweet.create content: params[:content], user_id: session[:id]

    if @tweet.valid?
      redirect '/tweets'
    else
      redirect '/tweets/new'
    end
  end

  get '/tweets/:id' do
    @tweet = Tweet.find params[:id]
    if is_logged_in?
      erb :'tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if is_logged_in?
      @tweet = current_user.tweets.find params[:id]
      erb :'tweets/edit_tweet'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    if is_logged_in?

      @tweet = current_user.tweets.find params[:id]
      @tweet.update(content: params[:content])
      if @tweet.valid?
        redirect "/tweets/#{@tweet.id}"
      else
        redirect "/tweets/#{@tweet.id}/edit"
      end
    else
      redirect '/login'
    end
  end

  delete '/tweets/:id' do
    if is_logged_in?
      @tweet = Tweet.find params[:id]

      if current_user.tweets.include?(@tweet)
        @tweet.delete
      end
      redirect '/tweets'
    else
      redirect '/login'
    end
  end
end
