class TweetsController < ApplicationController

  get '/tweets' do
    if !session[:user_id]
      redirect to '/login'
    else
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    end
  end

  get '/tweets/new' do
    if !session[:user_id]
      redirect to '/login'
    else
      erb :'tweets/create_tweet'
    end
  end

  post '/tweets' do
    if params[:content] == ""
      redirect to "/tweets/new"
    else
      user = User.find_by_id(session[:user_id])
      @tweet = Tweet.create(content: params[:content], user_id: user.id)
      redirect to "/tweets/#{@tweet.id}"
    end
  end

  get '/tweets/:id' do
    if !session[:user_id]
      redirect to '/login'
    else
      @tweet = Tweet.find_by(params[:id])
      erb :'tweets/show_tweet'
    end
  end

  get '/tweets/:id/edit' do
    if !session[:user_id]
      redirect to '/login'
    else
      @tweet = Tweet.find_by(params[:id])
      if @tweet.user_id == session[:user_id]
        erb :'tweets/edit_tweet'
      else
        redirect to '/tweets'
      end
    end
  end

  patch '/tweets/:id' do
    if params[:content] == ""
      redirect to "/tweets/#{params[:id]}/edit"
    else
      @tweet = Tweet.find_by(params[:id])
      @tweet.content = params[:content]
      @tweet.save
      redirect to "/tweets/#{@tweet.id}"
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by(params[:id])
    if !session[:user_id]
      redirect to '/login'
    else
      if @tweet.user_id == session[:user_id]
        @tweet.delete
        redirect to '/tweets'
      else
        redirect to '/tweets'
      end
    end
  end

end
