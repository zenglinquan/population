package cn.yxxrui.model;

public class Landlord {

	private int id;
	private String landlordName;
	private String password;
	private String telephone;
	private String identity;
	private String address;
	private int zoneId;
	
	public Landlord() {
	}

	public Landlord( String landlordName, String telephone, String identity, String address,
			int zoneId) {
		this.landlordName = landlordName;
		this.telephone = telephone;
		this.identity = identity;
		this.address = address;
		this.zoneId = zoneId;
	}

	
	public Landlord(int id,String address) {
		this.id = id;
		this.address = address;
	}
	public Landlord(String landlordName, String telephone, String identity) {
		this.landlordName = landlordName;
		this.telephone = telephone;
		this.identity = identity;
	}
	public Landlord(int id,String landlordName, String telephone, String identity) {
		this.id = id;
		this.landlordName = landlordName;
		this.telephone = telephone;
		this.identity = identity;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getLandlordName() {
		return landlordName;
	}

	public void setLandlordName(String landlordName) {
		this.landlordName = landlordName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getIdentity() {
		return identity;
	}

	public void setIdentity(String identity) {
		this.identity = identity;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getZoneId() {
		return zoneId;
	}

	public void setZoneId(int zoneId) {
		this.zoneId = zoneId;
	}

	@Override
	public String toString() {
		return "Landlord [id=" + id + ", landlordName=" + landlordName + ", password=" + password + ", telephone="
				+ telephone + ", identity=" + identity + ", address=" + address + ", zoneId=" + zoneId + "]";
	}

	
}
