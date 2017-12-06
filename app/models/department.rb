class Department < ApplicationRecord
	has_many :users

	has_many :lowers, class_name: 'Department', foreign_key: 'parent_id'
  	belongs_to :higher, class_name:  'Department', foreign_key: 'parent_id', optional: true

	# validates :department_name, :manager_name, presence: true   #这几个变量不能为空
 #  	validates :department_name, length: { in: 1..25 }, #长度1-25
 #                       uniqueness: { case_sensitive: false, message: "部门添加重复" }  #唯一性检测，不区分大小写
 #  	validates :manager_name, length: { in: 1..25 }, #长度1-25
 #  							 uniqueness: { case_sensitive: false, message: "此人已是某部门经理" }  #唯一性检测，不区分大小写
end
