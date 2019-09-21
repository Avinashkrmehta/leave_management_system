class CreateLeaves < ActiveRecord::Migration[5.2]
  def change
    create_table :leaves do |t|
      t.datetime :leave_apply
      t.datetime :leave_to
      t.datetime :leave_from
      t.text :reason
      t.integer :reporting_head
      t.belongs_to :user, index: true
      t.string :status

      t.timestamps
    end
  end
end
