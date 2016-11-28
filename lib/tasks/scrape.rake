namespace :scrape do
  namespace :nse do
    desc 'scrape nse nifty'
    task nifty: :environment do
      nse_nifty_url = "https://nseindia.com/live_market/dynaContent/live_watch/stock_watch/niftyStockWatch.json"
      stocks_json_s = Net::HTTP.get(URI.parse(nse_nifty_url))
      stock_json = JSON.parse(stocks_json_s)
      current_scrape_time = stock_json['time'].to_time
      stock_json['data'].each do |stock|
        mapped_stock =  NseScrapperMapper.new(stock)
        last_scrape_time = PriceUpdate.where(symbol: mapped_stock.symbol).maximum(:timestamp)
        if(last_scrape_time.nil? || current_scrape_time > last_scrape_time)
          PriceUpdate.create(mapped_stock.instance_values.merge({timestamp: current_scrape_time}))
        end
      end
    end

    desc 'scrape nse nifty historical data'
    task nifty_history: :environment do
      all_symbols = PriceUpdate.distinct(:symbol).pluck(:symbol)
      # all_symbols = ['INDUSINDBK']
      all_symbols.each do |symbol|
        puts "Scraping for #{symbol}"
        nse_nifty_url = "https://www.nseindia.com/live_market/dynaContent/live_watch/get_quote/getHistoricalData.jsp?symbol=#{symbol}&series=EQ&fromDate=undefined&toDate=undefined&datePeriod=12months"
        stocks_html_s = Net::HTTP.get(URI.parse(nse_nifty_url))
        parsed_html = Nokogiri::HTML(stocks_html_s)
        stock_rows = parsed_html.css('table tr:not(:first-child)')
        stock_rows.map do |row|
          price_attrs = {
            timestamp: row.children[0].child.text.strip.to_time,
            symbol: row.children[1].child.text.strip,
            open: row.children[3].child.text.strip.gsub(',' , '').to_f,
            high: row.children[4].child.text.strip.gsub(',' , '').to_f,
            low: row.children[5].child.text.strip.gsub(',' , '').to_f,
            last: row.children[6].child.text.strip.gsub(',' , '').to_f,
            volume: row.children[8].child.text.strip.gsub(',' , '').to_i
          }
          PriceUpdate.find_or_create_by(price_attrs)
        end
      end
    end
  end
end
