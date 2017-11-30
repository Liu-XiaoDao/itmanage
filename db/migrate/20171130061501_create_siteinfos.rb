class CreateSiteinfos < ActiveRecord::Migration[5.1]
  def change
    create_table :siteinfos do |t|
      t.string   'title'
      t.string   'emailrecive'
      t.timestamps
    end
  end
end
