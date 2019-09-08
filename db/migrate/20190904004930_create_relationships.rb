class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
    add_index :relationships, [:user_id, :group_id], unique: true
  end
end
