class CreateWhiteLists < ActiveRecord::Migration[5.1]
  def change
    create_table :white_lists do |t|
      t.string    'web_name'
      t.string    'url'
      t.string    'introduce'
      t.string    'requester'
      t.integer   'is_add',     default: 0
      t.timestamps
    end
  end
end
