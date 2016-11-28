class CreatePriceUpdates < ActiveRecord::Migration[5.0]
  def change
    create_table :price_updates do |t|
      t.string :symbol
      t.float :open
      t.float :high
      t.float :low
      t.float :last
      t.float :change
      t.float :change_percent
      t.integer :volume
      t.float :fifty_two_week_low
      t.float :fifty_two_week_high

      t.timestamps
    end
  end
end
