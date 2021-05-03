package com.lo.swipenote.util;

import com.google.api.client.http.AbstractInputStreamContent;
import com.google.api.client.http.GenericUrl;
import com.google.api.services.storage.Storage;
import com.google.api.services.storage.model.StorageObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;

@Component
public class GoogleStorageClientAdapter {
    private Storage storage;
    private String bucketName;

    public GoogleStorageClientAdapter(@Autowired Storage storage, @Value("${bucket}") String bucketName) {
        this.storage = storage;
        this.bucketName = bucketName;
    }

    public String upload(MultipartFile file) throws IOException {
    	System.out.println("fileName:::"+file.getOriginalFilename());
    	
    	
        StorageObject object = new StorageObject();
        String fileNm = System.currentTimeMillis()+"_"+file.getOriginalFilename();
        
        object.setName(fileNm);
        
        InputStream targetStream = new ByteArrayInputStream(file.getBytes());
        
        
        storage.objects().insert(bucketName, object, new AbstractInputStreamContent(file.getOriginalFilename()) {
            @Override
            public long getLength() throws IOException {
                return file.getSize();
            }

            @Override
            public boolean retrySupported() {
                return false;
            }

            @Override
            public InputStream getInputStream() throws IOException {
                return targetStream;
            }
        }).execute();
        
        return "https://storage.googleapis.com/"+this.bucketName+"/"+fileNm;
    }


    public StorageObject download(String fileName) throws IOException {
        StorageObject object = storage.objects().get(bucketName, fileName).execute();
        File file = new File("./" + fileName);
        FileOutputStream os = new FileOutputStream(file);

        storage.getRequestFactory()
                .buildGetRequest(new GenericUrl(object.getMediaLink()))
                .execute()
                .download(os);
        object.set("file", file);
        return object;
    }
}
