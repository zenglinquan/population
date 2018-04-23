package cn.yxxrui.service;

import java.util.List;

import cn.yxxrui.model.Zone;

public interface ZoneService {
	
	public List<Zone>getAllZone();
	public int addZone(Zone zone);
}
