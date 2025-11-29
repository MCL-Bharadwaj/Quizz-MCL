# LMS Authentication Flow Documentation

## Overview

This document describes the authentication and authorization flow for the Learning Management System (LMS) API. The system uses JWT (JSON Web Tokens) for stateless authentication with role-based access control (RBAC).

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Security Components](#security-components)
3. [Database Schema](#database-schema)
4. [Authentication Flow](#authentication-flow)
5. [Password Management](#password-management)
6. [JWT Token Management](#jwt-token-management)
7. [Role-Based Access Control](#role-based-access-control)
8. [API Endpoints](#api-endpoints)
9. [Security Best Practices](#security-best-practices)
10. [Error Handling](#error-handling)

---

## Architecture Overview

### High-Level Architecture

```
┌─────────────┐         ┌─────────────┐         ┌─────────────┐
│   Client    │────────►│  Azure      │────────►│  PostgreSQL │
│ Application │  HTTPS  │  Functions  │         │  Database   │
└─────────────┘         └─────────────┘         └─────────────┘
      │                        │
      │                        │
      └────────────────────────┘
           JWT Token Flow
```

### Key Components

1. **Client Application**: Web/Mobile app making API requests
2. **Azure Functions**: Serverless API endpoints
3. **TokenService**: JWT generation and validation
4. **PasswordService**: Password hashing and verification (BCrypt)
5. **PostgreSQL Database**: User credentials and role storage

---

## Security Components

### 1. Password Hashing (BCrypt)

**Location**: `ServiceAPI.Common.PasswordService`

```csharp
public static string HashPassword(string password)
{
    return BCrypt.Net.BCrypt.HashPassword(password, BCrypt.Net.BCrypt.GenerateSalt(12));
}

public static bool VerifyPassword(string password, string hash)
{
    return BCrypt.Net.BCrypt.Verify(password, hash);
}
```

**Key Features**:
- Uses BCrypt algorithm with salt round of 12
- One-way hashing (cannot be reversed)
- Salt automatically included in hash
- Resistant to rainbow table attacks
- Adaptive: can increase work factor over time

### 2. JWT Token Service

**Location**: `ServiceAPI.Common.TokenService`

**Configuration**:
- **Algorithm**: HMAC-SHA256
- **Issuer**: LMS-API
- **Audience**: LMS-Users
- **Expiration**: 24 hours (configurable)
- **Secret Key**: Stored in Azure Key Vault (production)

---

## Database Schema

### Users Table

The `lms.users` table stores user credentials:

| Column | Type | Description |
|--------|------|-------------|
| `user_id` | UUID | Primary key |
| `email` | VARCHAR(255) | Unique, used for login |
| `password_hash` | VARCHAR(255) | BCrypt hashed password |
| `first_name` | VARCHAR(100) | User's first name |
| `last_name` | VARCHAR(100) | User's last name |
| `is_active` | BOOLEAN | Account active status |
| `is_verified` | BOOLEAN | Email verification status |
| `last_login` | TIMESTAMP | Last successful login |
| `created_at` | TIMESTAMP | Account creation time |
| `updated_at` | TIMESTAMP | Last update time |

### Roles Table

The `lms.roles` table defines system roles:

```sql
- Student
- Tutors
- Parent
- Content Creator
- Administrator
```

### User Roles Table

The `lms.user_roles` table implements RBAC:

| Column | Type | Description |
|--------|------|-------------|
| `user_role_id` | UUID | Primary key |
| `user_id` | UUID | Reference to users |
| `role_id` | UUID | Reference to roles |
| `assigned_by` | UUID | Who assigned the role |
| `assigned_at` | TIMESTAMP | When assigned |
| `is_active` | BOOLEAN | Active status |

---

## Authentication Flow

### 1. User Registration Flow

```
┌─────────┐                ┌─────────┐                ┌──────────┐
│ Client  │                │   API   │                │ Database │
└────┬────┘                └────┬────┘                └────┬─────┘
     │                          │                          │
     │  POST /v1/auth/register  │                          │
     │ ───────────────────────► │                          │
     │  {email, password, ...}  │                          │
     │                          │                          │
     │                          │  Check if email exists   │
     │                          │ ────────────────────────►│
     │                          │                          │
     │                          │  Email not found         │
     │                          │ ◄────────────────────────│
     │                          │                          │
     │                          │  Hash password (BCrypt)  │
     │                          │ ──────────┐              │
     │                          │           │              │
     │                          │ ◄─────────┘              │
     │                          │                          │
     │                          │  Insert new user         │
     │                          │ ────────────────────────►│
     │                          │                          │
     │                          │  User created            │
     │                          │ ◄────────────────────────│
     │                          │                          │
     │                          │  Generate JWT token      │
     │                          │ ──────────┐              │
     │                          │           │              │
     │                          │ ◄─────────┘              │
     │                          │                          │
     │  201 Created             │                          │
     │  {userId, email, token}  │                          │
     │ ◄─────────────────────── │                          │
     │                          │                          │
```

**Step-by-Step Process**:

1. **Client sends registration request** with user details:
   ```json
   {
     "email": "user@example.com",
     "password": "SecurePass123!",
     "firstName": "John",
     "lastName": "Doe",
     "phone": "+1234567890"
   }
   ```

2. **API validates input**:
   - Email format validation
   - Password strength check (min 8 characters)
   - Required fields validation
   - Gender enum validation (if provided)

3. **Check for existing user**:
   ```csharp
   var existingUser = await _db.Users.FirstOrDefaultAsync(u => u.Email == dto.Email);
   if (existingUser != null)
       return BadRequest("Email already exists");
   ```

4. **Hash the password**:
   ```csharp
   var passwordHash = PasswordService.HashPassword(dto.Password);
   // Result: $2a$12$KIXxWlPQEp8Jq7vN... (60 chars)
   ```

5. **Create user record**:
   ```csharp
   var user = new User
   {
       Email = dto.Email,
       PasswordHash = passwordHash,  // Hashed, never plain text
       FirstName = dto.FirstName,
       LastName = dto.LastName,
       IsActive = true,
       IsVerified = false,
       CreatedAt = DateTimeOffset.UtcNow
   };
   ```

6. **Save to database**:
   ```csharp
   _db.Users.Add(user);
   await _db.SaveChangesAsync();
   ```

7. **Generate JWT token**:
   ```csharp
   var token = _tokenService.GenerateToken(user.UserId, user.Email, roles);
   ```

8. **Return response** (201 Created):
   ```json
   {
     "userId": "123e4567-e89b-12d3-a456-426614174000",
     "email": "user@example.com",
     "firstName": "John",
     "lastName": "Doe",
     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
     "roles": []
   }
   ```

---

### 2. User Login Flow

```
┌─────────┐                ┌─────────┐                ┌──────────┐
│ Client  │                │   API   │                │ Database │
└────┬────┘                └────┬────┘                └────┬─────┘
     │                          │                          │
     │  POST /v1/auth/login     │                          │
     │ ───────────────────────► │                          │
     │  {email, password}       │                          │
     │                          │                          │
     │                          │  Find user by email      │
     │                          │ ────────────────────────►│
     │                          │  Include roles           │
     │                          │                          │
     │                          │  User + Roles            │
     │                          │ ◄────────────────────────│
     │                          │                          │
     │                          │  Verify password         │
     │                          │ ──────────┐              │
     │                          │  BCrypt    │              │
     │                          │ ◄─────────┘              │
     │                          │                          │
     │                          │  Update last_login       │
     │                          │ ────────────────────────►│
     │                          │                          │
     │                          │  Generate JWT token      │
     │                          │ ──────────┐              │
     │                          │           │              │
     │                          │ ◄─────────┘              │
     │                          │                          │
     │  200 OK                  │                          │
     │  {userId, email, token}  │                          │
     │ ◄─────────────────────── │                          │
     │                          │                          │
```

**Step-by-Step Process**:

1. **Client sends login request**:
   ```json
   {
     "email": "user@example.com",
     "password": "SecurePass123!"
   }
   ```

2. **API validates input**:
   ```csharp
   if (string.IsNullOrEmpty(dto.Email) || string.IsNullOrEmpty(dto.Password))
       return BadRequest("Email and password are required");
   ```

3. **Query database for user**:
   ```csharp
   var user = await _db.Users
       .Include(u => u.UserRoles)
       .ThenInclude(ur => ur.Role)
       .FirstOrDefaultAsync(u => u.Email == dto.Email);
   
   if (user == null)
       return Unauthorized("Invalid email or password");
   ```

4. **Verify password**:
   ```csharp
   if (!PasswordService.VerifyPassword(dto.Password, user.PasswordHash))
       return Unauthorized("Invalid email or password");
   ```
   
   **BCrypt Verification Process**:
   - Extracts salt from stored hash
   - Hashes provided password with same salt
   - Compares hashes in constant time (prevents timing attacks)

5. **Check account status**:
   ```csharp
   if (!user.IsActive)
       return Unauthorized("Account deactivated");
   ```

6. **Update last login timestamp**:
   ```csharp
   user.LastLogin = DateTimeOffset.UtcNow;
   await _db.SaveChangesAsync();
   ```

7. **Get user roles**:
   ```csharp
   var roles = user.UserRoles.Select(ur => ur.Role.RoleName).ToList();
   // Example: ["Student", "Content Creator"]
   ```

8. **Generate JWT token**:
   ```csharp
   var token = _tokenService.GenerateToken(user.UserId, user.Email, roles);
   ```

9. **Return response** (200 OK):
   ```json
   {
     "userId": "123e4567-e89b-12d3-a456-426614174000",
     "email": "user@example.com",
     "firstName": "John",
     "lastName": "Doe",
     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
     "roles": ["Student", "Content Creator"]
   }
   ```

---

### 3. Authenticated API Request Flow

```
┌─────────┐                ┌─────────┐                ┌──────────┐
│ Client  │                │   API   │                │ Database │
└────┬────┘                └────┬────┘                └────┬─────┘
     │                          │                          │
     │  GET /v1/students/me     │                          │
     │  Authorization: Bearer   │                          │
     │  {JWT token}             │                          │
     │ ───────────────────────► │                          │
     │                          │                          │
     │                          │  Validate JWT token      │
     │                          │ ──────────┐              │
     │                          │  - Verify signature      │
     │                          │  - Check expiration      │
     │                          │  - Extract userId        │
     │                          │ ◄─────────┘              │
     │                          │                          │
     │                          │  Query data with userId  │
     │                          │ ────────────────────────►│
     │                          │                          │
     │                          │  Return data             │
     │                          │ ◄────────────────────────│
     │                          │                          │
     │  200 OK                  │                          │
     │  {student data}          │                          │
     │ ◄─────────────────────── │                          │
     │                          │                          │
```

**Authorization Header Format**:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

---

## Password Management

### Password Hashing Process

**BCrypt Algorithm**:

1. **Generate Salt**:
   ```csharp
   var salt = BCrypt.Net.BCrypt.GenerateSalt(12);
   // workFactor = 12 means 2^12 = 4,096 rounds
   ```

2. **Hash Password**:
   ```csharp
   var hash = BCrypt.Net.BCrypt.HashPassword(password, salt);
   ```

3. **Stored Hash Format**:
   ```
   $2a$12$KIXxWlPQEp8Jq7vNZvJ3R.wE4xqZ3FkB5LxWzM9hkY9K6jLdDqZyq
    │  │  │                             │
    │  │  │                             └─ 31-char hash
   │  │  └─ 22-char salt
   │  └─ Work factor (12)
   └─ Algorithm version (2a)
   ```

### Password Verification Process

```csharp
public static bool VerifyPassword(string password, string hash)
{
    try
    {
        // BCrypt extracts salt from hash and verifies
        return BCrypt.Net.BCrypt.Verify(password, hash);
    }
    catch
    {
        return false; // Invalid hash or verification failed
    }
}
```

**Verification Steps**:
1. Extract salt and parameters from stored hash
2. Hash the provided password with extracted salt
3. Compare hashes using constant-time comparison
4. Return true if match, false otherwise

### Password Security Features

✅ **Implemented**:
- BCrypt hashing with salt round 12
- Minimum 8 characters length requirement
- One-way hashing (irreversible)
- Constant-time comparison (prevents timing attacks)

📋 **Recommended Additions**:
- Password complexity requirements (uppercase, lowercase, numbers, symbols)
- Password history (prevent reuse of last N passwords)
- Account lockout after failed attempts
- Password expiration policy
- Multi-factor authentication (MFA)

---

## JWT Token Management

### Token Generation

**TokenService.GenerateToken()**:

```csharp
public string GenerateToken(Guid userId, string email, List<string> roles)
{
    var claims = new List<Claim>
    {
        new Claim(JwtRegisteredClaimNames.Sub, userId.ToString()),
        new Claim(JwtRegisteredClaimNames.Email, email),
        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
        new Claim("userId", userId.ToString())
    };

    // Add roles as claims
    foreach (var role in roles)
    {
        claims.Add(new Claim(ClaimTypes.Role, role));
    }

    var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_secretKey));
    var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

    var token = new JwtSecurityToken(
        issuer: _issuer,
        audience: _audience,
        claims: claims,
        expires: DateTime.UtcNow.AddHours(24),
        signingCredentials: credentials
    );

    return new JwtSecurityTokenHandler().WriteToken(token);
}
```

### Token Structure

**JWT Token Format**: `header.payload.signature`

**Example Decoded Token**:

```json
// Header
{
  "alg": "HS256",
  "typ": "JWT"
}

// Payload
{
  "sub": "123e4567-e89b-12d3-a456-426614174000",
  "email": "user@example.com",
  "jti": "9a8b7c6d-5e4f-3a2b-1c0d-9e8f7a6b5c4d",
  "userId": "123e4567-e89b-12d3-a456-426614174000",
  "role": ["Student", "Content Creator"],
  "iss": "LMS-API",
  "aud": "LMS-Users",
  "exp": 1731628800
}

// Signature
HMACSHA256(
  base64UrlEncode(header) + "." + base64UrlEncode(payload),
  secret
)
```

### Token Validation

**TokenService.ValidateToken()**:

```csharp
public Guid? ValidateToken(string token)
{
    try
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.UTF8.GetBytes(_secretKey);

        tokenHandler.ValidateToken(token, new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(key),
            ValidateIssuer = true,
            ValidIssuer = _issuer,
            ValidateAudience = true,
            ValidAudience = _audience,
            ValidateLifetime = true,
            ClockSkew = TimeSpan.Zero // No grace period
        }, out SecurityToken validatedToken);

        var jwtToken = (JwtSecurityToken)validatedToken;
        var userIdClaim = jwtToken.Claims.First(x => x.Type == "userId").Value;

        return Guid.Parse(userIdClaim);
    }
    catch
    {
        return null; // Invalid token
    }
}
```

**Validation Checks**:
1. ✅ Signature verification
2. ✅ Issuer validation
3. ✅ Audience validation
4. ✅ Expiration check
5. ✅ Token format

---

## Role-Based Access Control

### RBAC Implementation

**Database Structure**:

```
users (user_id) ──┐
                  │
                  ├──► user_roles (user_id, role_id) ──┐
                  │                                      │
roles (role_id) ──┘                                     │
                                                         │
                              JWT Token ◄────────────────┘
                              Contains role claims
```

### Role Assignment

**Query to get user roles**:

```csharp
var user = await _db.Users
    .Include(u => u.UserRoles)
    .ThenInclude(ur => ur.Role)
    .FirstOrDefaultAsync(u => u.Email == email);

var roles = user.UserRoles
    .Where(ur => ur.IsActive)
    .Select(ur => ur.Role.RoleName)
    .ToList();
```

### Role-Based Authorization

**Example: Protect API endpoint**:

```csharp
[Function("GetAllStudents")]
[OpenApiOperation(operationId: "GetAllStudents", tags: new[] { "Students" })]
public async Task<HttpResponseData> GetAllStudents(
    [HttpTrigger(AuthorizationLevel.Function, "get", Route = "v1/students")] 
    HttpRequestData req)
{
    // Extract token from Authorization header
    var token = req.Headers.GetValues("Authorization")
        .FirstOrDefault()?.Replace("Bearer ", "");
    
    if (string.IsNullOrEmpty(token))
        return await req.UnauthorizedAsync("Token required");
    
    // Validate token
    var userId = _tokenService.ValidateToken(token);
    if (userId == null)
        return await req.UnauthorizedAsync("Invalid token");
    
    // Check user roles
    var user = await _db.Users
        .Include(u => u.UserRoles)
        .ThenInclude(ur => ur.Role)
        .FirstOrDefaultAsync(u => u.UserId == userId);
    
    var roles = user.UserRoles.Select(ur => ur.Role.RoleName).ToList();
    
    // Check if user has required role
    if (!roles.Contains("Administrator") && !roles.Contains("Tutors"))
        return await req.ForbiddenAsync("Insufficient permissions");
    
    // Proceed with business logic
    var students = await _db.Students.ToListAsync();
    return await req.OkAsync(students);
}
```

---

## API Endpoints

### Authentication Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/v1/auth/register` | Register new user | No |
| POST | `/v1/auth/login` | Login user | No |
| POST | `/v1/auth/refresh` | Refresh token | Yes |
| POST | `/v1/auth/logout` | Logout user | Yes |
| POST | `/v1/auth/forgot-password` | Request password reset | No |
| POST | `/v1/auth/reset-password` | Reset password | No |
| POST | `/v1/auth/verify-email` | Verify email | Yes |
| GET | `/v1/auth/me` | Get current user | Yes |

### Request/Response Examples

**POST /v1/auth/register**

Request:
```json
{
  "email": "john.doe@example.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe",
  "phone": "+1234567890",
  "gender": "Male"
}
```

Response (201 Created):
```json
{
  "userId": "123e4567-e89b-12d3-a456-426614174000",
  "email": "john.doe@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "roles": []
}
```

**POST /v1/auth/login**

Request:
```json
{
  "email": "john.doe@example.com",
  "password": "SecurePass123!"
}
```

Response (200 OK):
```json
{
  "userId": "123e4567-e89b-12d3-a456-426614174000",
  "email": "john.doe@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "roles": ["Student"]
}
```

---

## Security Best Practices

### ✅ Currently Implemented

1. **Password Security**
   - BCrypt hashing with salt round 12
   - Passwords never stored in plain text
   - Minimum 8 character requirement

2. **JWT Security**
   - HMAC-SHA256 signing algorithm
   - 24-hour token expiration
   - Token signature verification
   - Issuer and audience validation

3. **API Security**
   - HTTPS encryption (in production)
   - Input validation
   - Error message sanitization (no information leakage)

4. **Database Security**
   - UUID primary keys (prevents enumeration)
   - Parameterized queries (prevents SQL injection)
   - Foreign key constraints

### 🔒 Recommended Enhancements

1. **Multi-Factor Authentication (MFA)**
   - SMS/Email OTP
   - Authenticator app support
   - Backup codes

2. **Token Management**
   - Refresh tokens for long-lived sessions
   - Token revocation/blacklisting
   - Device tracking
   - Concurrent session limits

3. **Password Policies**
   - Complexity requirements
   - Password history (prevent reuse)
   - Password expiration
   - Breach detection (HaveIBeenPwned API)

4. **Account Security**
   - Failed login attempt tracking
   - Account lockout mechanism
   - CAPTCHA after failed attempts
   - Suspicious activity alerts

5. **Audit Logging**
   - Login/logout events
   - Failed authentication attempts
   - Password changes
   - Role assignments
   - Suspicious activities

6. **Secret Management**
   - Move JWT secret to Azure Key Vault
   - Rotate secrets periodically
   - Environment-specific secrets

7. **Rate Limiting**
   - Limit login attempts per IP
   - API request throttling
   - DDoS protection

---

## Error Handling

### Authentication Error Responses

**400 Bad Request**:
```json
{
  "error": "Invalid request body",
  "details": "Email is required"
}
```

**401 Unauthorized**:
```json
{
  "error": "Invalid email or password"
}
```

**403 Forbidden**:
```json
{
  "error": "Insufficient permissions",
  "details": "Administrator role required"
}
```

**409 Conflict**:
```json
{
  "error": "A user with this email already exists"
}
```

### Security Considerations for Errors

✅ **Do**:
- Use generic messages for authentication failures
- Log detailed errors server-side
- Return consistent response times (prevent timing attacks)

❌ **Don't**:
- Reveal whether email exists
- Expose password validation rules in error messages
- Include stack traces in responses
- Differentiate between "user not found" and "wrong password"

---

## Implementation Checklist

### Current Implementation Status

- [x] User registration with BCrypt password hashing
- [x] User login with password verification
- [x] JWT token generation with user claims
- [x] JWT token validation
- [x] Role-based access control (RBAC) data model
- [x] User roles stored in database
- [x] Roles included in JWT token
- [x] Last login tracking
- [x] Account active/inactive status
- [x] Email uniqueness validation
- [x] Password strength validation (basic)

### Recommended Additions

- [ ] Refresh token mechanism
- [ ] Token blacklist/revocation
- [ ] Multi-factor authentication (MFA)
- [ ] Email verification flow
- [ ] Password reset flow
- [ ] Account lockout after failed attempts
- [ ] Password complexity requirements
- [ ] Password history
- [ ] Audit logging for security events
- [ ] Rate limiting on auth endpoints
- [ ] CAPTCHA integration
- [ ] Session management
- [ ] Device tracking
- [ ] Azure Key Vault for secrets
- [ ] API documentation with security schemes

---

## Configuration

### Development Environment

```json
{
  "JwtSettings": {
    "SecretKey": "development-secret-key-min-32-characters-long",
    "Issuer": "LMS-API",
    "Audience": "LMS-Users",
    "ExpirationHours": 24
  },
  "BCryptSettings": {
    "WorkFactor": 12
  }
}
```

### Production Environment

```json
{
  "JwtSettings": {
    "SecretKey": "@Microsoft.KeyVault(SecretUri=https://your-keyvault.vault.azure.net/secrets/jwt-secret)",
    "Issuer": "https://api.lms.com",
    "Audience": "https://lms.com",
    "ExpirationHours": 24
  },
  "BCryptSettings": {
    "WorkFactor": 12
  }
}
```

---

## Testing

### Unit Tests Example

```csharp
[Fact]
public void HashPassword_ShouldReturnDifferentHashForSamePassword()
{
    var password = "TestPassword123!";
    var hash1 = PasswordService.HashPassword(password);
    var hash2 = PasswordService.HashPassword(password);
    
    Assert.NotEqual(hash1, hash2); // Different salts
    Assert.True(PasswordService.VerifyPassword(password, hash1));
    Assert.True(PasswordService.VerifyPassword(password, hash2));
}

[Fact]
public void GenerateToken_ShouldCreateValidToken()
{
    var tokenService = new TokenService("test-secret-key-must-be-32-chars");
    var userId = Guid.NewGuid();
    var email = "test@example.com";
    var roles = new List<string> { "Student" };
    
    var token = tokenService.GenerateToken(userId, email, roles);
    
    Assert.NotNull(token);
    Assert.NotEmpty(token);
    
    var validatedUserId = tokenService.ValidateToken(token);
    Assert.Equal(userId, validatedUserId);
}
```

---

## Conclusion

This authentication system provides a solid foundation for secure user authentication using industry-standard practices:

- **BCrypt** for password hashing
- **JWT** for stateless authentication
- **RBAC** for authorization
- **PostgreSQL** for credential storage

For production deployment, consider implementing the recommended enhancements, particularly MFA, refresh tokens, and comprehensive audit logging.

---

**Document Version**: 1.0  
**Last Updated**: November 14, 2025  
**Authors**: LMS Development Team
