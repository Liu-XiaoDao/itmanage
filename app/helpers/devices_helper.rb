module DevicesHelper


  def device_assetno(device_id)   #返回设备编号
      if device_id
      device = Device.find device_id
        link_to device.asset_code, device_path(device)
    else
      '无'
    end
  end

  def isscrap(is_scrap)   #返回设备状态
      case is_scrap
        when 0
          "维保期,可正常使用"
      when 1
           "已超过维保,请回收报废或续保"
      else
         "状态不详"
      end
    end

end
