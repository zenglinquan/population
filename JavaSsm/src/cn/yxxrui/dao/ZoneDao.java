package cn.yxxrui.dao;

import java.util.List;
import java.util.Map;

import cn.yxxrui.model.Zone;

public interface ZoneDao {
	public List<Zone> getAllZone();
	public List<Zone> getZonePageInfo(Map<String, Object> map);
	public Long getTotal();
	
	public String getZoneNameById(int zoneId);
	public int getZoneIdByZoneName(String zoneName);
	
	public int addZone(Zone zone);
}
