package com.lo.swipenote.controller.api;

import com.lo.swipenote.util.GoogleStorageClientAdapter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;


@RestController
public class GoogleStorageController {
    @Autowired
    private GoogleStorageClientAdapter googleStorageClientAdapter;

  
    
    @PostMapping(path = "/upload", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public HashMap<String, Object> uploadFile(@RequestPart(value = "file", required = true) MultipartFile files)  {
    	HashMap<String, Object> model = new HashMap<String, Object>();
		try{
			model.put("uploadUrl", googleStorageClientAdapter.upload(files));
        }catch(IOException e){
        	model.put("error", e.getMessage());
        }
        return model;
    }
    
}