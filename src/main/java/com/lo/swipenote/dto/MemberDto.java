package com.lo.swipenote.dto;

import java.sql.Date;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.Setter;

@Alias("memberDto") 
public class MemberDto
{
	private int membNo;
	private String id; 
	private String pwd; 
	private String nickname; 
	private String email;
	private String profileUrl;
	private String useYn;
	private Date insDate;
	private Date uptDate;
	public int getMembNo() {
		return membNo;
	}
	public void setMembNo(int membNo) {
		this.membNo = membNo;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getProfileUrl() {
		return profileUrl;
	}
	public void setProfileUrl(String profileUrl) {
		this.profileUrl = profileUrl;
	}
	public String getUseYn() {
		return useYn;
	}
	public void setUseYn(String useYn) {
		this.useYn = useYn;
	}
	public Date getInsDate() {
		return insDate;
	}
	public void setInsDate(Date insDate) {
		this.insDate = insDate;
	}
	public Date getUptDate() {
		return uptDate;
	}
	public void setUptDate(Date uptDate) {
		this.uptDate = uptDate;
	}
	@Override
	public String toString() {
		return "MemberDto [membNo=" + membNo + ", id=" + id + ", pwd=" + pwd + ", nickname=" + nickname + ", email="
				+ email + ", profileUrl=" + profileUrl + ", useYn=" + useYn + ", insDate=" + insDate + ", uptDate="
				+ uptDate + "]";
	}
	
}


