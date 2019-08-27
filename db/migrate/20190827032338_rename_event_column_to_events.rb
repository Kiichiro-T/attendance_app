class RenameEventColumnToEvents < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :event, :event_name
  end
end
