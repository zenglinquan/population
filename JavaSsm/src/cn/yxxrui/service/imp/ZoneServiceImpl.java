package cn.yxxrui.service.imp;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.yxxrui.dao.ZoneDao;
import cn.yxxrui.model.Zone;
import cn.yxxrui.service.ZoneService;
@Service
public class ZoneServiceImpl implements ZoneService{

	@Resource
	ZoneDao zoneDao;

	@Override
	public List<Zone> getAllZone() {
		List<Zone> zoneList = zoneDao.getAllZone();
		return zoneList;
	}

	@Override
	public int addZone(Zone zone) {
		
		return zoneDao.addZone(zone);
	}
	
	
}
