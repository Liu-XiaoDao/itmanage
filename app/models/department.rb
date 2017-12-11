class Department < ApplicationRecord
	has_many :users

	has_many :lowers, class_name: 'Department', foreign_key: 'parent_id'
  	belongs_to :higher, class_name:  'Department', foreign_key: 'parent_id', optional: true

	validates :department_name, :manager_name, presence: true   #这几个变量不能为空
  	validates :department_name, length: { in: 1..25 } #长度1-25     
  	validates :manager_name, length: { in: 1..25 } #长度1-25



  	def self.alltree
  		@departmentss = Department.all
    	@departments = []
    	GetTree(@departmentss,0,0,@departments,'----')
    	return @departments
  	end

  		#部门分类缩进
    def self.GetTree(arr,pid,step,newarr,indentstr)
	  	for item in arr
		   if item['parent_id'] == pid
	            indent = indentstr * step
	            item['department_name'] = indent + item['department_name']
	            newarr.push item
	            GetTree(arr , item['id'] ,step+1,newarr,indentstr)
	        end
		end
    end
end
