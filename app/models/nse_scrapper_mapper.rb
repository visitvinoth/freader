class NseScrapperMapper
  SCRAPPER_MAP = {
    'symbol' => 'symbol',
    'open' => 'open',
    'high' => 'high',
    'low' => 'low',
    'last' => 'ltP',
    'change' => 'ptsC',
    'change_percent' => 'per',
    'volume' => 'trdVol',
    'fifty_two_week_low' => 'wklo',
    'fifty_two_week_high' => 'wkhi'
  }
  SCRAPPER_MAP.keys.each do |k|
    attr_accessor k
  end
  def initialize(scrapped_stock)
    SCRAPPER_MAP.each do |key, value|
      self.send("#{key}=", scrapped_stock[value])
    end
  end
end
