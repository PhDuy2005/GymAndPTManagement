package com.se100.GymAndPTManagement.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class FileService {
    @Value("${se100.upload-file.base-uri}")
    private String baseURI;

    public void createUploadFolder(String folder) throws URISyntaxException {
        // Chuyển đổi đường dẫn folder thành URI
        java.net.URI uri = new java.net.URI(folder);

        // Chuyển URI thành Path object
        Path path = Paths.get(uri);

        // Tạo File object từ Path
        java.io.File tmpDir = path.toFile();

        // Kiểm tra xem thư mục đã tồn tại chưa
        if (!tmpDir.isDirectory()) {
            try {
                // Tạo thư mục và tất cả thư mục cha (nếu cần)
                Files.createDirectory(tmpDir.toPath());
                System.out.println(">>> CREATE NEW DIRECTORY SUCCESSFUL, PATH = " + tmpDir.toPath());
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println(">>> SKIP MAKING DIRECTORY, ALREADY EXISTS");
        }
    }

    public String store(MultipartFile file, String folder) throws URISyntaxException, IOException {
        // create unique filename
        String finalName = System.currentTimeMillis() + "-" + file.getOriginalFilename();

        java.net.URI uri = new java.net.URI(baseURI + folder + "/" + finalName);
        Path path = Paths.get(uri);
        try (InputStream inputStream = file.getInputStream()) {
            Files.copy(inputStream, path,
                    StandardCopyOption.REPLACE_EXISTING);
        }
        return finalName;
    }

    public Long getFileLength(String fileName, String folder)
            throws URISyntaxException, IOException {
        java.net.URI uri = new java.net.URI(baseURI + folder + "/" + fileName);
        Path path = Paths.get(uri);

        File tmpDir = new File(path.toString());

        // Kiểm tra xem file có tồn tại không, hoặc nếu file là 1 director => trả về 0
        if (!tmpDir.exists() || tmpDir.isDirectory()) {
            return 0L;
        }
        return tmpDir.length();
    }

    public InputStreamResource getResource(String fileName, String folder)
            throws URISyntaxException, IOException, FileNotFoundException {
        java.net.URI uri = new java.net.URI(baseURI + folder + "/" + fileName);
        Path path = Paths.get(uri);

        File file = new File(path.toString());

        FileInputStream inputStream = new FileInputStream(file);
        return new InputStreamResource(inputStream);
    }
}