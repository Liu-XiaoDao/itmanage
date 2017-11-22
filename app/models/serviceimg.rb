class Serviceimg < ApplicationRecord
	belongs_to :deviceservice, optional: true   #一条记录包含一张图片,属于一个服务
end
