class AddUrlTokenToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :url_token, :string
    add_index  :events, :url_token, unique: true
  end
end
