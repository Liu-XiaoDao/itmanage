class RemoveAttendanceAvatarFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column(:users, :attendance)
    remove_column(:users, :avatar)
  end
end
