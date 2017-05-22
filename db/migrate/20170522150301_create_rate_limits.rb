class CreateRateLimits < ActiveRecord::Migration[5.1]
  def change
    create_table :rate_limits do |t|
      t.string :ip_address
      t.datetime :requested_at
    end
    add_index :rate_limits, :ip_address
    add_index :rate_limits, :requested_at
  end
end
