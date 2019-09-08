class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :event
      t.datetime :date
      t.text :memo
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      

      t.timestamps
    end
    add_index :events, [:user_id, :group_id, :created_at]
  end
end
