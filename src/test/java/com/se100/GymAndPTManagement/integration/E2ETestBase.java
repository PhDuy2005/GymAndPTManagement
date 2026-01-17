package com.se100.GymAndPTManagement.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;

/**
 * Base class for E2E REST API tests using MockMvc
 * Provides request/response helpers and common utilities for testing REST endpoints
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
public abstract class E2ETestBase {

    @Autowired
    protected MockMvc mockMvc;

    @Autowired
    protected ObjectMapper objectMapper;

    /**
     * Clear security context before test
     */
    protected void clearSecurityContext() {
        SecurityContextHolder.clearContext();
    }

    /**
     * Set authentication context for JWT-protected requests
     */
    protected void setAuthenticationContext(String email) {
        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_MEMBER"));

        UsernamePasswordAuthenticationToken token =
                new UsernamePasswordAuthenticationToken(email, null, authorities);
        SecurityContextHolder.getContext().setAuthentication(token);
    }

    /**
     * Perform GET request and return MvcResult
     */
    protected MvcResult performGet(String url) throws Exception {
        return mockMvc.perform(get(url).accept(MediaType.APPLICATION_JSON)).andReturn();
    }

    /**
     * Perform POST request with JSON body
     */
    protected MvcResult performPost(String url, Object requestBody) throws Exception {
        return mockMvc.perform(post(url)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(requestBody))
                .accept(MediaType.APPLICATION_JSON))
                .andReturn();
    }

    /**
     * Perform PUT request with JSON body
     */
    protected MvcResult performPut(String url, Object requestBody) throws Exception {
        return mockMvc.perform(put(url)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(requestBody))
                .accept(MediaType.APPLICATION_JSON))
                .andReturn();
    }

    /**
     * Perform DELETE request
     */
    protected MvcResult performDelete(String url) throws Exception {
        return mockMvc.perform(delete(url).accept(MediaType.APPLICATION_JSON)).andReturn();
    }

    /**
     * Extract JSON response as Map
     */
    protected Map<String, Object> parseResponse(MvcResult result) throws Exception {
        String content = result.getResponse().getContentAsString();
        return objectMapper.readValue(content, Map.class);
    }

    /**
     * Extract data field from response
     */
    protected Map<String, Object> getDataFromResponse(MvcResult result) throws Exception {
        Map<String, Object> response = parseResponse(result);
        return (Map<String, Object>) response.get("data");
    }

    /**
     * Get HTTP status code from response
     */
    protected int getStatusCode(MvcResult result) {
        return result.getResponse().getStatus();
    }

    /**
     * Get error message from response
     */
    protected String getErrorMessage(MvcResult result) throws Exception {
        Map<String, Object> response = parseResponse(result);
        return (String) response.get("message");
    }

    /**
     * Assert response status code
     */
    protected void assertStatusCode(int expected, MvcResult result) {
        assert result.getResponse().getStatus() == expected :
                "Expected status " + expected + " but got " + result.getResponse().getStatus();
    }

    /**
     * Assert response success structure
     */
    protected void assertResponseSuccess(MvcResult result, int expectedStatus) throws Exception {
        assertStatusCode(expectedStatus, result);
        Map<String, Object> response = parseResponse(result);
        assert response.containsKey("data") : "Response missing 'data' field";
    }

    /**
     * Assert response error structure
     */
    protected void assertResponseError(MvcResult result, int expectedStatus) throws Exception {
        assertStatusCode(expectedStatus, result);
        Map<String, Object> response = parseResponse(result);
        assert response.containsKey("message") : "Error response missing 'message' field";
    }
}
