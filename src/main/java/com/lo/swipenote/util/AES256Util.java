package com.lo.swipenote.util;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.AlgorithmParameterSpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/** AES256 암호화 유틸(양방향)
 * @author 편범삼
 * */
@Component
public class AES256Util 
{
	//iv 바이트 배열
	public byte[] ivBytes = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
	
	//암호화 키 주입
	@Value("${aes256key}")
	private  String key;
	
	 /**
	  * 일반 문자열을 지정된 키를 이용하여 AES256 으로 암호화
	  * @param   	암호화 대상 문자열
	  * @param   	문자열 암호화에 사용될 키
	  * @return 	key 로 암호화된  문자열 
	  */
	 public String strEncode(String str)	throws java.io.UnsupportedEncodingException
												 , NoSuchAlgorithmException
												 , NoSuchPaddingException
												 , InvalidKeyException
												 , InvalidAlgorithmParameterException
												 , IllegalBlockSizeException
												 , BadPaddingException
	 {
		 byte[] textBytes = str.getBytes("UTF-8");
		 AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		 SecretKeySpec newKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
		 Cipher cipher = null;
		 cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		 cipher.init(Cipher.ENCRYPT_MODE, newKey, ivSpec);
		 return Base64.encodeBase64String(cipher.doFinal(textBytes));
	 }

 
 
	 /**
	  * 암호화된 문자열을 지정된 키를 이용하여 AES256 으로 복호화
	  * @param   복호화 대상 문자열
	  * @param   문자열 복호화에 사용될 키
	  * @return  key 로 복호화된  문자열 
	  */ 
	 public String strDecode(String str)	throws java.io.UnsupportedEncodingException
												 , NoSuchAlgorithmException
												 , NoSuchPaddingException
												 , InvalidKeyException
												 , InvalidAlgorithmParameterException
												 , IllegalBlockSizeException
												 , BadPaddingException 
	 {
		 byte[] textBytes = Base64.decodeBase64(str);
		 AlgorithmParameterSpec ivSpec = new IvParameterSpec(ivBytes);
		 SecretKeySpec newKey = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
		 Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
		 cipher.init(Cipher.DECRYPT_MODE, newKey, ivSpec);
		 return new String(cipher.doFinal(textBytes), "UTF-8");
	 }
	 
}


