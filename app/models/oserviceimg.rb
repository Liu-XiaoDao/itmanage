class Oserviceimg < ApplicationRecord
	belongs_to :otherservice, optional: true   #一条记录包含一张图片,属于一个服务
end
