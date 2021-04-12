package com.lo.swipenote.util;

import java.security.MessageDigest;

import org.springframework.stereotype.Component;

@Component
public class SHA256Util {
	public static String encodeSHA256(String str) {
		try{

			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(str.getBytes("UTF-8"));
			StringBuffer hexString = new StringBuffer();

			for (int i = 0; i < hash.length; i++) {
				String hex = Integer.toHexString(0xff & hash[i]);
				if(hex.length() == 1) hexString.append('0');
				hexString.append(hex);
			}

			//출력
			return hexString.toString();
			
		} catch(Exception ex){
			throw new RuntimeException(ex);
		}
	}
}