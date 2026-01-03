# Password Hashing Algorithm

**Category**: Authentication & Authorization  
**Algorithm**: BCrypt  
**Strength**: 10 rounds (default)  
**Author**: System  
**Date**: 2026-01-03

---

## 📋 Mô Tả

Thuật toán mã hóa password sử dụng BCrypt trước khi lưu vào database. BCrypt là một hàm hash password được thiết kế để chống brute-force attacks bằng cách có computational cost cao.

---

## 💻 Implementation

### Hash Password

```java
/**
 * Hash password using BCrypt
 * @param plainPassword - Password người dùng nhập vào
 * @return Hashed password
 */
public String hashPassword(String plainPassword) {
    PasswordEncoder encoder = new BCryptPasswordEncoder();
    return encoder.encode(plainPassword);
}
```

### Verify Password

```java
/**
 * Verify password
 * @param plainPassword - Password người dùng nhập vào
 * @param hashedPassword - Password đã hash trong database
 * @return true nếu match, false nếu không match
 */
public boolean verifyPassword(String plainPassword, String hashedPassword) {
    PasswordEncoder encoder = new BCryptPasswordEncoder();
    return encoder.matches(plainPassword, hashedPassword);
}
```

---

## ⚙️ Configuration

**Strength/Rounds**: 10 (default của BCryptPasswordEncoder)
- Có thể điều chỉnh bằng constructor: `new BCryptPasswordEncoder(12)`
- Giá trị càng cao = càng an toàn nhưng càng chậm
- Khuyến nghị: 10-12 rounds

---

## 📝 Usage

```java
// Hash password khi register
String plainPassword = "userPassword123";
String hashedPassword = hashPassword(plainPassword);
user.setPassword(hashedPassword);
userRepository.save(user);

// Verify password khi login
String inputPassword = "userPassword123";
String storedHash = user.getPassword();
boolean isValid = verifyPassword(inputPassword, storedHash);
```

---

## 🔒 Security Notes

1. **Không bao giờ lưu plain text password**
2. **Không log password** (plain hoặc hashed)
3. **Sử dụng PasswordEncoder bean** đã config trong SecurityConfiguration
4. **Salt tự động**: BCrypt tự động generate salt cho mỗi password
5. **One-way hash**: Không thể decrypt từ hash về plain text

---

## 🚨 Edge Cases

- **Null password**: Throw exception, không hash
- **Empty password**: Throw exception, không hash  
- **Very long password**: BCrypt có giới hạn 72 bytes, truncate nếu dài hơn

---

## 🧪 Testing

```java
@Test
public void testPasswordHashing() {
    String plain = "testPassword123";
    String hash1 = hashPassword(plain);
    String hash2 = hashPassword(plain);
    
    // Different hashes (different salt)
    assertNotEquals(hash1, hash2);
    
    // Both verify correctly
    assertTrue(verifyPassword(plain, hash1));
    assertTrue(verifyPassword(plain, hash2));
    
    // Wrong password fails
    assertFalse(verifyPassword("wrongPassword", hash1));
}
```

---

## 📚 References

- [BCrypt Algorithm](https://en.wikipedia.org/wiki/Bcrypt)
- [Spring Security BCryptPasswordEncoder](https://docs.spring.io/spring-security/site/docs/current/api/org/springframework/security/crypto/bcrypt/BCryptPasswordEncoder.html)
- [OWASP Password Storage](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)

---

**Version**: 1.0  
**Last Updated**: 2026-01-03
