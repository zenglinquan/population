package cn.yxxrui.dto;

public class AssistantInfo {
	private String assistantName;

	
	public AssistantInfo() {
	}


	public AssistantInfo(String assistantName) {
		this.assistantName = assistantName;
	}


	public String getAssistantName() {
		return assistantName;
	}


	public void setAssistantName(String assistantName) {
		this.assistantName = assistantName;
	}


	@Override
	public String toString() {
		return "AssistantInfo [assistantName=" + assistantName + "]";
	}
	
	
}
