package com.lo.swipenote.dto;

import java.sql.Date;

/** 회원정보 DTO
 * @author 편범삼
 */

public class MemberDto
{
	//회원 번호 (pk)
	private int membNo;
	
	//아이디
	private String id;
	
	//패스워드
	private String pwd;
	
	//닉네임
	private String nickname;
	
	//이메일
	private String email;
	
	//프로필 이미지 경로
	private String profileUrl;
	
	//배경 이미지 경로
	private String bgUrl;
	
	//사용여부
	private String useYn;
	
	//가입일
	private Date insDate;
	
	//정보 수정일
	private Date uptDate;
	
	//getter And Setter
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
	
	public String getBgUrl() {
		return bgUrl;
	}
	public void setBgUrl(String bgUrl) {
		this.bgUrl = bgUrl;
	}
	/** 디버깅용 toString
	 * */
	@Override
	public String toString() {
		return "MemberDto [membNo=" + membNo + ", id=" + id + ", pwd=" + pwd + ", nickname=" + nickname + ", email="
				+ email + ", profileUrl=" + profileUrl + ", useYn=" + useYn + ", insDate=" + insDate + ", uptDate="
				+ uptDate + "]";
	}
	
}


