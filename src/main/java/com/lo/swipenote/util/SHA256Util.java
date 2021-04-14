package com.lo.swipenote.util;

import java.security.MessageDigest;

import org.springframework.stereotype.Component;

@Component
public class SHA256Util {
	public static String encodeSHA256(String str) {
		try{

			  StringBuffer sbuf = new StringBuffer();
			     
			    MessageDigest mDigest = MessageDigest.getInstance("SHA-256");
			    mDigest.update(str.getBytes());
			     
			    byte[] msgStr = mDigest.digest() ;
			     
			    for(int i=0; i < msgStr.length; i++){
			        byte tmpStrByte = msgStr[i];
			        String tmpEncTxt = Integer.toString((tmpStrByte & 0xff) + 0x100, 16).substring(1);
			         
			        sbuf.append(tmpEncTxt) ;
			    }
			     
			    return sbuf.toString();
			
		} catch(Exception ex){
			throw new RuntimeException(ex);
		}
	}
}