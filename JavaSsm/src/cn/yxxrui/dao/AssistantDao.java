package cn.yxxrui.dao;

import java.util.List;
import java.util.Map;

import cn.yxxrui.model.Assistant;

public interface AssistantDao {

	public List<Assistant> getAllAssistant(Map<String, Object> map);
	public Long getTotal();
	
	public int addAssistant(Assistant assistant);
}
