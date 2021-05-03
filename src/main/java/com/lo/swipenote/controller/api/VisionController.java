package com.lo.swipenote.controller.api;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gcp.vision.CloudVisionTemplate;
import org.springframework.core.io.ResourceLoader;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

/** 이미지 to 텍스트 구글 vision api 요청 컨트롤러
 * @author 편범삼
 * */
@RestController
public class VisionController {

	@Autowired 
	private ResourceLoader resourceLoader;

	@Autowired 
	private CloudVisionTemplate cloudVisionTemplate;

	
	@PostMapping("/convImgToTxt")
	public HashMap<String, Object> convImgToTxt(String imageUrl) {
		
		System.out.println("imageUrl:::"+imageUrl);
		
		String textFromImage = cloudVisionTemplate.extractTextFromImage(resourceLoader.getResource(imageUrl));
		
		HashMap<String, Object> model = new HashMap<String, Object>();
		model.put("result", textFromImage);
		return model;
	}
}
