package com.lo.swipenote.util;

import java.security.MessageDigest;

import org.springframework.stereotype.Component;

/** SHA256 암호화 유틸(단방향)
 * @author 편범삼
 * */
@Component
public class SHA256Util {
	
	/** 암호화 
	 * @param str 암호화할 문자열
	 * @return
	 * */
	public static String encodeSHA256(String str) {
		try{
			//암호화할 문자를 담을 스트링버퍼 객체
			StringBuffer sbuf = new StringBuffer();
		     
			//메시지 암호화할 DIGEST 객체
		    MessageDigest mDigest = MessageDigest.getInstance("SHA-256");
		    
		    //암호화할 문자열 세팅
		    mDigest.update(str.getBytes());
		     
		    //바이트 배열로 전환
		    byte[] msgStr = mDigest.digest() ;
		     
		    //각 바이트를 암호화
		    for(int i=0; i < msgStr.length; i++){
		        byte tmpStrByte = msgStr[i];
		        String tmpEncTxt = Integer.toString((tmpStrByte & 0xff) + 0x100, 16).substring(1);
		        
		        //암호화한 내용을 버퍼에 세팅
		        sbuf.append(tmpEncTxt) ;
		    }
		    
		    //암호화 내용 반환
		    return sbuf.toString();
		
		} catch(Exception ex){
			//예외 발생 시 상위 메소드로 throw
			throw new RuntimeException(ex);
		}
	}
}