package com.se100.GymAndPTManagement.controller;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.se100.GymAndPTManagement.domain.responseDTO.ResUploadFileDTO;
import com.se100.GymAndPTManagement.service.FileService;
import com.se100.GymAndPTManagement.util.annotation.ApiMessage;
import com.se100.GymAndPTManagement.util.error.StorageException;

@RestController
@RequestMapping("/api/v1")
public class FileController {

    private final FileService fileService;

    public FileController(FileService fileService) {
        this.fileService = fileService;
    }

    @Value("${se100.upload-file.base-uri}")
    private String baseURI;

    @PostMapping("/files")
    @ApiMessage("Upload single file to server")
    public ResponseEntity<ResUploadFileDTO> uploadFile(
            @RequestParam(name = "file", required = false) MultipartFile file,
            @RequestParam(name = "folder") String folder) throws URISyntaxException, IOException, StorageException {

        // validate
        // file is not null or empty
        if (file == null || file.isEmpty()) {
            throw new StorageException("File is required");
        }

        String fileName = file.getOriginalFilename();
        List<String> allowedExtensions = List.of("png", "jpg", "jpeg", "gif", "pdf", "doc", "docx");
        List<String> allowedMimeTypes = Arrays.asList(
                "application/pdf",
                "image/jpeg",
                "image/png",
                "application/msword",
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
        // validate extension
        boolean isValid = allowedExtensions.stream()
                .anyMatch(ext -> fileName != null && fileName.toLowerCase().endsWith("." + ext));

        if (!isValid) {
            throw new StorageException("File type is not allowed. Only allow: " + String.join(", ", allowedExtensions));
        }

        // Validate MIME type
        String contentType = file.getContentType();
        if (!allowedMimeTypes.contains(contentType)) {
            // return ResponseEntity.badRequest().body("Invalid file type based on MIME
            // type.");
            throw new StorageException("Invalid file type based on MIME type.");
        }

        // Tạo thư mục nếu chưa tồn tại
        this.fileService.createUploadFolder(baseURI + folder);
        // lưu file vào thư mục
        String uploadedFile = this.fileService.store(file, folder);

        // return file.getOriginalFilename().toString() + " uploaded to folder " +
        // folder;
        return ResponseEntity.ok(new ResUploadFileDTO(uploadedFile, java.time.Instant.now()));
    }

    @GetMapping("/files")
    @ApiMessage("Download file from server")
    public ResponseEntity<Resource> downloadFile(
            @RequestParam(name = "fileName", required = false) String fileName,
            @RequestParam(name = "folder", required = false) String folder)
            throws URISyntaxException, IOException, StorageException {

        if (fileName == null || fileName.isEmpty()) {
            throw new StorageException("File name is required");
        }

        // check file exists in folder
        Long fileLength = this.fileService.getFileLength(fileName, folder);
        if (fileLength == null || fileLength <= 0) {
            throw new StorageException("File not found");
        }

        // download file logic here
        InputStreamResource resource = this.fileService.getResource(fileName, folder);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                .contentLength(fileLength)
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(resource);
    }

}
