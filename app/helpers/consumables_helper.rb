module ConsumablesHelper
	def consumable_name(consumable_id)   #根据用户id返回用户名
		consumable = Consumable.find consumable_id
	    consumable.name
	end
end
