class AddTimestampToPriceUpdate < ActiveRecord::Migration[5.0]
  def change
    add_column :price_updates, :timestamp, :timestamp
  end
end
