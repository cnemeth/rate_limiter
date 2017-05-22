class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.string :ip_address
      t.datetime :requested_at
    end
    add_index :requests, :ip_address
    add_index :requests, :requested_at
  end
end
