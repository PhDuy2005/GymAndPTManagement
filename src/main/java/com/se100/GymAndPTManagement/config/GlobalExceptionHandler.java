package com.se100.GymAndPTManagement.config;

import org.springframework.data.mapping.PropertyReferenceException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.se100.GymAndPTManagement.domain.responseDTO.RestResponse;

import java.util.logging.Logger;

@RestControllerAdvice
public class GlobalExceptionHandler {
    
    private static final Logger logger = Logger.getLogger(GlobalExceptionHandler.class.getName());

    /**
     * Handle PropertyReferenceException from Spring Data (malformed sort parameters)
     */
    @ExceptionHandler(PropertyReferenceException.class)
    public ResponseEntity<RestResponse<Void>> handlePropertyReferenceException(PropertyReferenceException ex) {
        logger.warning("PropertyReferenceException: " + ex.getMessage());
        
        RestResponse<Void> response = RestResponse.<Void>builder()
                .statusCode(400)
                .message("Invalid sort parameter. Please use valid field names (e.g., ?sort=id,asc)")
                .build();
        
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }

    /**
     * Handle general IllegalArgumentException
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<RestResponse<Void>> handleIllegalArgumentException(IllegalArgumentException ex) {
        logger.warning("IllegalArgumentException: " + ex.getMessage());
        
        RestResponse<Void> response = RestResponse.<Void>builder()
                .statusCode(400)
                .message(ex.getMessage())
                .build();
        
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }
}
