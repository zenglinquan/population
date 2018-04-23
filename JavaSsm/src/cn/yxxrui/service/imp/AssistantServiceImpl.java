package cn.yxxrui.service.imp;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.yxxrui.dao.AssistantDao;
import cn.yxxrui.dao.ZoneDao;
import cn.yxxrui.model.Assistant;
import cn.yxxrui.service.AssistantService;
@Service
public class AssistantServiceImpl implements AssistantService {

	@Resource
	AssistantDao assistantDao;
	@Resource
	ZoneDao zoneDao;
	
	@Override
	public int addAssistant(Assistant assistant) {
		int zoneId = zoneDao.getZoneIdByZoneName(assistant.getZoneName());
		assistant.setZoneId(zoneId);
		 
		int success = assistantDao.addAssistant(assistant);
		return success;
	}
}
