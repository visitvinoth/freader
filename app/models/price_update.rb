class PriceUpdate < ApplicationRecord

  def self.for(symbol = nil, lim = 120 )
    l = PriceUpdate.order('timestamp desc')
    l = l.where(symbol: symbol) if symbol.present?
    l = l.limit(lim ) if lim.present?
    l = l.sort_by(&:timestamp)
    last_high = l.first.high
    last_low = l.first.low
    l.each_cons(2).each do |g|
      date = g[1].timestamp.in_time_zone("Chennai").to_date
      is_buy_signal = false
      is_sell_signal = false
      curr_high = g[1].high 
      curr_low = g[1].low 
      past_high = g[0].high 
      past_low = g[0].low 
      curr_swing_high = (g[1].high-g[0].high).round(2)
      curr_swing_low = (g[1].high-g[0].low).round(2)
      # binding.pry if date >= '12-11-2015'.to_date
      if ((curr_swing_high > 0) && (last_high < curr_high))
        last_high = curr_high
        is_buy_signal = true
      end
      if ((curr_swing_low > 0) && (curr_high < last_low))
        last_low = curr_low
        is_sell_signal = true
      end
      if is_buy_signal
        if is_sell_signal
          signal = 'HOLD'
        else
          signal = 'BUY'
        end
      elsif is_sell_signal
        signal = 'SELL'
      end

      puts "D: #{date}, H: #{curr_high}, Lo: #{curr_low}" + 
      # " -- swing-high: #{curr_swing_high} -- swing-low: #{curr_swing_low} -- " +
      " -- last-high: #{last_high} -- last-low: #{last_low} -- " +
      "<<#{signal}>>" 

    end
  end
end
