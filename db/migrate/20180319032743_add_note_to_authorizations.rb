class AddNoteToAuthorizations < ActiveRecord::Migration[5.1]
  def change
    add_column :authorizations, :note, :text
  end
end
