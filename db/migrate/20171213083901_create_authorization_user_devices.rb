class CreateAuthorizationUserDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :authorization_user_devices do |t|
 	  t.references 	'user'
	  t.references 	'device'
	  t.references  'authorization'
	  t.string      'note'                  #备注
      t.timestamps
    end
  end
end
