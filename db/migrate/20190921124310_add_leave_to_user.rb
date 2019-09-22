class AddLeaveToUser < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :max_leave, :integer
  	add_column :users, :username, :string
  	add_column :users, :role, :string
  end
end
