package com.lo.swipenote.controller.api;

import com.lo.swipenote.util.GoogleStorageClientAdapter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gcp.vision.CloudVisionTemplate;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;


@RestController
public class GCPController {
    @Autowired
    private GoogleStorageClientAdapter googleStorageClientAdapter;

	@Autowired 
	private ResourceLoader resourceLoader;

	@Autowired 
	private CloudVisionTemplate cloudVisionTemplate;

    
    @PostMapping(path = "/convImgToTxt", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public HashMap<String, Object> uploadFile(@RequestPart(value = "file", required = true) MultipartFile files)  {
    	HashMap<String, Object> model = new HashMap<String, Object>();
		try{
			
			String imageUrl = googleStorageClientAdapter.upload(files);
			
			String textFromImage = cloudVisionTemplate.extractTextFromImage(resourceLoader.getResource(imageUrl));
			
			model.put("result", textFromImage);
        }catch(IOException e){
        	model.put("error", e.getMessage());
        }
        return model;
    }
    
}