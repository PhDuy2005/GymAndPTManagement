# Algorithm Template

> Template này dùng để tạo documentation cho thuật toán mới. Copy và điền thông tin.

---

**Category**: {Authentication & Authorization | Data Validation | Search & Filter | Pagination | Other}  
**Algorithm**: {Tên thuật toán}  
**Author**: {Tên người tạo}  
**Date**: {YYYY-MM-DD}

---

## 📋 Mô Tả

{Mô tả chi tiết thuật toán: mục đích, use case, khi nào sử dụng}

---

## ⚙️ Configuration (nếu có)

| Parameter   | Value     | Description |
| ----------- | --------- | ----------- |
| {Tham số 1} | {Giá trị} | {Mô tả}     |
| {Tham số 2} | {Giá trị} | {Mô tả}     |

---

## 💻 Implementation

### {Tên method/function chính}

```java
/**
 * {Javadoc description}
 * @param {param1} - {Description}
 * @param {param2} - {Description}
 * @return {Return value description}
 */
public {ReturnType} {methodName}({ParamType} {param1}, {ParamType} {param2}) {
    // Implementation code
}
```

### {Tên method/function phụ} (nếu có)

```java
// Additional methods if needed
```

---

## 📊 Algorithm Flow (nếu phức tạp)

```
Step 1: {Description}
   ↓
Step 2: {Description}
   ↓
Step 3: {Description}
   ↓
Result: {Output}
```

Hoặc dùng diagram:

```
┌─────────────────────────┐
│  Input                  │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Process Step 1         │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Process Step 2         │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Output                 │
└─────────────────────────┘
```

---

## 📝 Usage

```java
// Example usage code
{ClassName} instance = new {ClassName}();
{ReturnType} result = instance.{methodName}(param1, param2);

// Example with real values
```

---

## ⏱️ Complexity Analysis (nếu cần)

- **Time Complexity**: O({complexity})
- **Space Complexity**: O({complexity})
- **Explanation**: {Giải thích về độ phức tạp}

---

## 🔒 Security Notes (nếu liên quan bảo mật)

1. {Security consideration 1}
2. {Security consideration 2}
3. {Security consideration 3}

---

## 🚨 Edge Cases

- **{Edge case 1}**: {How to handle}
- **{Edge case 2}**: {How to handle}
- **{Edge case 3}**: {How to handle}

---

## 🧪 Testing

```java
@Test
public void test{AlgorithmName}() {
    // Arrange
    {SetupCode}
    
    // Act
    {ReturnType} result = {methodCall}
    
    // Assert
    {Assertions}
}

@Test
public void test{EdgeCase}() {
    // Test edge case
}
```

---

## 🔄 Alternative Approaches (nếu có)

### Approach 1: {Name}
- **Pros**: {Advantages}
- **Cons**: {Disadvantages}
- **When to use**: {Use case}

### Approach 2: {Name}
- **Pros**: {Advantages}
- **Cons**: {Disadvantages}
- **When to use**: {Use case}

---

## 📚 References

- [{Reference title 1}]({URL})
- [{Reference title 2}]({URL})
- [{Reference title 3}]({URL})

---

## 🔧 Maintenance Notes (optional)

- {Note về việc maintain thuật toán}
- {Những điều cần lưu ý khi modify}
- {Dependencies với các components khác}

---

**Version**: 1.0  
**Last Updated**: {YYYY-MM-DD}  
**Reviewed by**: {Tên người review} (optional)
