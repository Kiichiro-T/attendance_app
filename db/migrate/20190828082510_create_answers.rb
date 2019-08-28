class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.integer :status
      t.text :reason
      t.text :remarks
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true

      t.timestamps
    end
     add_index :answers, [:user_id, :event_id, :created_at]
  end
end
