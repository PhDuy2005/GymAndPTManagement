package com.se100.GymAndPTManagement.service;

import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.se100.GymAndPTManagement.domain.requestDTO.ReqCreateUserDTO;
import com.se100.GymAndPTManagement.domain.responseDTO.ResUserDTO;
import com.se100.GymAndPTManagement.domain.table.Role;
import com.se100.GymAndPTManagement.domain.table.User;
import com.se100.GymAndPTManagement.repository.RoleRepository;
import com.se100.GymAndPTManagement.repository.UserRepository;
import com.se100.GymAndPTManagement.util.enums.UserStatusEnum;

import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final RoleRepository roleRepository;

    public User handleFindByUsername(String username) {
        return userRepository.findByEmail(username).orElse(null);
    }

    public void updateUserRefreshToken(String token, String email) {
        User user = handleFindByUsername(email);
        if (user != null) {
            user.setRefreshToken(token);
            userRepository.save(user);
        }
    }

    /**
     * Find employee by email and refresh token.
     * 
     * @param email        the user's email.
     * @param refreshToken the refresh token to match.
     * @return User if found with matching token, null otherwise.
     */
    public User handleFindByEmailAndRefreshToken(String email, String refreshToken) {
        return this.userRepository.findByEmailAndRefreshToken(email, refreshToken);
    }

    /**
     * Handle logout user by clearing their refresh token.
     * 
     * @throws NoSuchElementException if the user with the given email does not
     *                                exist.
     * @param email the email of the user to log out.
     * @return If successful, returns nothing.
     */
    public void handleLogOutUser(@NotNull String email) {
        User user = handleFindByUsername(email);
        if (user == null) {
            throw new NoSuchElementException("User with email " + email + " does not exist");
        }
        user.setRefreshToken(null);
        userRepository.save(user);
    }

    /**
     * Create new user with specified role
     * 
     * @param request DTO containing user creation info
     * @return Response DTO with created user data
     * @throws IllegalArgumentException if email already exists or role not found
     */
    @Transactional
    public ResUserDTO createUser(ReqCreateUserDTO request) {
        // Validate email không trùng
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email đã tồn tại trong hệ thống");
        }

        // Get role by name
        Role role = roleRepository.findByName(request.getRoleName());
        if (role == null) {
            throw new IllegalArgumentException("Role '" + request.getRoleName() + "' not found in the system");
        }

        // Tạo User entity
        String finalPassword = (request.getPassword() == null || request.getPassword().trim().isEmpty())
                ? "12345678"
                : request.getPassword();

        User user = User.builder()
                .fullname(request.getFullname())
                .email(request.getEmail())
                .passwordHash(passwordEncoder.encode(finalPassword))
                .phoneNumber(request.getPhoneNumber())
                .avatarUrl(request.getAvatarUrl())
                .dob(request.getDob())
                .gender(request.getGender())
                .status(request.getStatus() != null ? request.getStatus() : UserStatusEnum.ACTIVE)
                .role(role)
                .build();

        // Save User
        User savedUser = userRepository.save(user);

        // Convert to DTO
        return convertToDTO(savedUser);
    }

    /**
     * Convert User entity to ResUserDTO
     */
    private ResUserDTO convertToDTO(User user) {
        if (user == null) {
            return null;
        }

        return ResUserDTO.builder()
                .id(user.getId())
                .fullname(user.getFullname())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .avatarUrl(user.getAvatarUrl())
                .dob(user.getDob())
                .gender(user.getGender())
                .status(user.getStatus())
                .build();
    }
}
