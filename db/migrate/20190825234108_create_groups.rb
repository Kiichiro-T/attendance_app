class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.text :explanation
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :groups, [:user_id, :created_at]
  end
end
