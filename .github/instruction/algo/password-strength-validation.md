# Password Strength Validation Algorithm

**Category**: Data Validation  
**Algorithm**: Custom Password Complexity Check  
**Author**: System  
**Date**: 2026-01-03

---

## 📋 Mô Tả

Thuật toán kiểm tra độ mạnh của password dựa trên các yêu cầu về độ phức tạp. Đảm bảo password đủ an toàn trước khi cho phép người dùng đăng ký hoặc thay đổi password.

---

## ⚙️ Configuration

**Minimum Requirements**:
- Độ dài: Ít nhất 8 ký tự
- Có thể thêm requirements sau: chữ hoa, chữ thường, số, ký tự đặc biệt

---

## 💻 Implementation

### Basic Validation (Using Jakarta Validation)

```java
@NotBlank(message = "Mật khẩu không được để trống")
@Size(min = 8, message = "Mật khẩu phải có ít nhất 8 ký tự")
private String password;
```

### Advanced Validation (Custom Implementation)

```java
/**
 * Validate password strength
 * Requirements:
 * - At least 8 characters
 * - At least one uppercase letter
 * - At least one lowercase letter
 * - At least one digit
 * - At least one special character
 * 
 * @param password - Password cần kiểm tra
 * @return true nếu password đủ mạnh, false nếu không
 */
public boolean isStrongPassword(String password) {
    if (password == null || password.length() < 8) {
        return false;
    }
    
    boolean hasUpper = password.chars().anyMatch(Character::isUpperCase);
    boolean hasLower = password.chars().anyMatch(Character::isLowerCase);
    boolean hasDigit = password.chars().anyMatch(Character::isDigit);
    boolean hasSpecial = password.chars().anyMatch(ch -> 
        "!@#$%^&*()_+-=[]{}|;:,.<>?".indexOf(ch) >= 0
    );
    
    return hasUpper && hasLower && hasDigit && hasSpecial;
}
```

---

## 📝 Usage

### In Service Layer

```java
public void registerUser(ReqRegisterDTO dto) {
    // Validate password strength
    if (!isStrongPassword(dto.getPassword())) {
        throw new ValidationException("Password không đủ mạnh. " +
            "Yêu cầu: ít nhất 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt");
    }
    
    // Hash and save
    String hashedPassword = passwordEncoder.encode(dto.getPassword());
    user.setPassword(hashedPassword);
    userRepository.save(user);
}
```

### Custom Validator Annotation (Advanced)

```java
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = StrongPasswordValidator.class)
public @interface StrongPassword {
    String message() default "Password không đủ mạnh";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}

// Validator implementation
public class StrongPasswordValidator implements ConstraintValidator<StrongPassword, String> {
    @Override
    public boolean isValid(String password, ConstraintValidatorContext context) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean hasUpper = password.chars().anyMatch(Character::isUpperCase);
        boolean hasLower = password.chars().anyMatch(Character::isLowerCase);
        boolean hasDigit = password.chars().anyMatch(Character::isDigit);
        boolean hasSpecial = password.chars().anyMatch(ch -> 
            "!@#$%^&*()_+-=[]{}|;:,.<>?".indexOf(ch) >= 0
        );
        
        return hasUpper && hasLower && hasDigit && hasSpecial;
    }
}

// Usage in DTO
@StrongPassword
private String password;
```

---

## 🔒 Security Notes

1. **Client-side validation**: Chỉ là UX improvement, LUÔN validate ở server-side
2. **Error messages**: Không nên reveal quá nhiều thông tin về requirements (để tránh brute-force)
3. **Configurable requirements**: Nên cho phép adjust requirements dựa trên security policy
4. **Password history**: Có thể thêm check để prevent reuse old passwords

---

## 🚨 Edge Cases

- **Null password**: Return false hoặc throw exception
- **Empty password**: Return false
- **Very long password**: Có thể set max length (e.g., 128 chars) để tránh DoS
- **Unicode characters**: Cần quyết định có accept hay không (e.g., emoji, Chinese characters)
- **Spaces**: Có thể allow spaces trong password

---

## 📊 Strength Levels (Optional Enhancement)

```java
public enum PasswordStrength {
    WEAK,      // Only basic requirements
    MEDIUM,    // 8-12 chars with complexity
    STRONG,    // 13-16 chars with complexity
    VERY_STRONG // 17+ chars with complexity
}

public PasswordStrength evaluatePasswordStrength(String password) {
    if (!isStrongPassword(password)) {
        return PasswordStrength.WEAK;
    }
    
    int length = password.length();
    if (length >= 17) return PasswordStrength.VERY_STRONG;
    if (length >= 13) return PasswordStrength.STRONG;
    if (length >= 8) return PasswordStrength.MEDIUM;
    
    return PasswordStrength.WEAK;
}
```

---

## 🧪 Testing

```java
@Test
public void testStrongPassword() {
    // Valid strong passwords
    assertTrue(isStrongPassword("Pass123!@#"));
    assertTrue(isStrongPassword("MySecure#Pass1"));
    
    // Invalid passwords
    assertFalse(isStrongPassword("pass123"));       // No uppercase, no special
    assertFalse(isStrongPassword("PASSWORD123!"));  // No lowercase
    assertFalse(isStrongPassword("Password!"));     // No digit
    assertFalse(isStrongPassword("Pass1234"));      // No special char
    assertFalse(isStrongPassword("Pass1!"));        // Too short
    assertFalse(isStrongPassword(null));            // Null
    assertFalse(isStrongPassword(""));              // Empty
}
```

---

## 📚 References

- [OWASP Password Requirements](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html#implement-proper-password-strength-controls)
- [NIST Password Guidelines](https://pages.nist.gov/800-63-3/sp800-63b.html)
- [Jakarta Bean Validation](https://beanvalidation.org/)

---

**Version**: 1.0  
**Last Updated**: 2026-01-03
