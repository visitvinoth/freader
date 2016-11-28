class PostsController < ApplicationController
  def index
    url = params[:url]
    binding.pry
    url = 'https://nseindia.com/live_market/dynaContent/live_watch/stock_watch/niftyStockWatch.json'
    feed = Feedjira::Feed.fetch_and_parse(url)
    render json: feed.entries.to_json
  end
end