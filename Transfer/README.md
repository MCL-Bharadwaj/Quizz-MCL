# Authentication, Authorization & Token Management Files

This folder contains all the files related to authentication, authorization, and token management from the LMS project.

## 📁 Folder Structure

```
Transfer/
├── Common/
│   ├── Services/
│   │   ├── AuthenticationService.cs        # Business logic for login, registration, password management
│   │   ├── AuthorizationService.cs         # JWT validation and role-based authorization
│   │   └── TokenService.cs                 # JWT generation and validation
│   ├── Utilities/
│   │   ├── PasswordService.cs              # BCrypt password hashing and verification
│   │   └── JsonConverters.cs               # TimeOnly and DateOnly JSON converters
│   └── Extensions/
│       └── Results.cs                      # HTTP response helpers and ProblemDetails
├── Configuration/
│   ├── AppOptions.cs                       # Configuration classes (JwtOptions, DbOptions, etc.)
│   └── OpenApiAuthConfiguration.cs         # Swagger JWT authentication setup
├── HTTP/
│   └── AuthFunctions.cs                    # Authentication API endpoints (Register, Login, etc.)
├── Domain/
│   └── Dtos/
│       └── UserDtos.cs                     # All authentication DTOs
├── Documentation/
│   ├── AUTHENTICATION_FLOW.md              # Detailed authentication flow documentation
│   ├── AUTHENTICATION_SERVICE_ARCHITECTURE.md  # Service architecture explanation
│   └── AUTHORIZATION_SERVICE_GUIDE.md      # Authorization service usage guide
└── README.md                               # This file
```

## 🚀 Quick Setup Guide

### 1. Required NuGet Packages

Add these packages to your `.csproj` file:

```xml
<ItemGroup>
  <!-- Azure Functions Worker -->
  <PackageReference Include="Microsoft.Azure.Functions.Worker" Version="1.21.0" />
  <PackageReference Include="Microsoft.Azure.Functions.Worker.Extensions.Http" Version="3.1.0" />
  
  <!-- OpenAPI / Swagger -->
  <PackageReference Include="Microsoft.Azure.Functions.Worker.Extensions.OpenApi" Version="1.5.1" />
  
  <!-- Entity Framework Core + PostgreSQL (or your database) -->
  <PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.0.10" />
  <PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="8.0.8" />
  
  <!-- Authentication -->
  <PackageReference Include="BCrypt.Net-Next" Version="4.0.3" />
  <PackageReference Include="Microsoft.IdentityModel.Tokens" Version="8.14.0" />
  <PackageReference Include="System.IdentityModel.Tokens.Jwt" Version="8.14.0" />
</ItemGroup>
```

### 2. Configuration (appsettings.json or local.settings.json)

```json
{
  "Jwt": {
    "SecretKey": "your-super-secret-key-change-this-in-production-min-32-chars!",
    "Issuer": "YourAPI",
    "Audience": "YourUsers",
    "ExpirationHours": 24
  },
  "Db": {
    "ConnectionString": "your-database-connection-string"
  }
}
```

### 3. Service Registration (Program.cs)

```csharp
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.EntityFrameworkCore;
using YourNamespace.Common.Services;
using YourNamespace.Configuration;
using System.Text.Json;

var host = new HostBuilder()
    .ConfigureFunctionsWorkerDefaults(builder =>
    {
        // Configure JSON serialization for TimeOnly and DateOnly
        builder.Services.Configure<JsonSerializerOptions>(options =>
        {
            options.Converters.Add(new TimeOnlyJsonConverter());
            options.Converters.Add(new DateOnlyJsonConverter());
            options.PropertyNameCaseInsensitive = true;
            options.PropertyNamingPolicy = JsonNamingPolicy.CamelCase;
        });
    })
    .ConfigureServices((ctx, services) =>
    {
        // Configure strongly-typed options
        services.Configure<JwtOptions>(ctx.Configuration.GetSection("Jwt"));
        services.Configure<DbOptions>(ctx.Configuration.GetSection("Db"));

        // Configure EF Core with your database
        var connectionString = ctx.Configuration.GetSection("Db:ConnectionString").Value;
        services.AddDbContext<YourDbContext>(opt =>
        {
            opt.UseNpgsql(connectionString); // Or UseSqlServer, etc.
        });

        // Register TokenService as singleton
        services.AddSingleton<TokenService>(sp =>
        {
            var jwtConfig = ctx.Configuration.GetSection("Jwt");
            var secretKey = jwtConfig["SecretKey"] ?? "fallback-key";
            var issuer = jwtConfig["Issuer"] ?? "API";
            var audience = jwtConfig["Audience"] ?? "Users";
            var expirationHours = int.TryParse(jwtConfig["ExpirationHours"], out var hours) ? hours : 24;
            
            return new TokenService(secretKey, issuer, audience, expirationHours);
        });

        // Register authentication and authorization services
        services.AddScoped<AuthenticationService>();
        services.AddScoped<AuthorizationService>();
    })
    .Build();

await host.RunAsync();
```

### 4. Database Schema

You'll need these tables:

```sql
-- Users table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(50),
    address1 VARCHAR(255),
    address2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    profile_picture_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Roles table
CREATE TABLE roles (
    role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- User roles table
CREATE TABLE user_roles (
    user_role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
    assigned_by UUID REFERENCES users(user_id),
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE(user_id, role_id)
);

-- Insert default roles
INSERT INTO roles (role_name, description) VALUES
('Administrator', 'System administrators with full access'),
('Tutors', 'Teachers/Tutors conducting classes'),
('Student', 'Students enrolled in classes'),
('Parent', 'Parents/Guardians of students'),
('Content Creator', 'Users who create and manage program content');
```

## 🔑 Key Features

### Authentication
- ✅ User registration with validation
- ✅ User login with credentials
- ✅ Password change functionality
- ✅ Password reset flow (forgot password)
- ✅ Email verification support
- ✅ BCrypt password hashing (salt round 12)
- ✅ Last login tracking

### Authorization
- ✅ JWT token generation (HMAC-SHA256)
- ✅ JWT token validation
- ✅ Role-based access control (RBAC)
- ✅ Roles embedded in JWT claims (no DB lookup)
- ✅ 24-hour token expiration (configurable)
- ✅ Convenient role checking methods

### Security
- ✅ Passwords never stored in plain text
- ✅ One-way BCrypt hashing
- ✅ Constant-time password comparison
- ✅ Token signature verification
- ✅ Token expiration validation
- ✅ Issuer and audience validation
- ✅ RFC 7807 ProblemDetails error responses

## 📚 Usage Examples

### Register New User

```csharp
POST /v1/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe",
  "phone": "+1234567890",
  "gender": "Male"
}

Response: 201 Created
{
  "userId": "123e4567-e89b-12d3-a456-426614174000",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "roles": []
}
```

### Login

```csharp
POST /v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!"
}

Response: 200 OK
{
  "userId": "123e4567-e89b-12d3-a456-426614174000",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "roles": ["Student"]
}
```

### Protected Endpoint Example

```csharp
[Function("GetMyProfile")]
public async Task<HttpResponseData> GetMyProfile(HttpRequestData req)
{
    // Validate token (any authenticated user)
    var auth = _authService.ValidateToken(req);
    if (!auth.IsAuthorized)
        return auth.ErrorResponse!;
    
    var userId = auth.UserId!.Value;
    var user = await _db.Users.FindAsync(userId);
    
    return await req.OkAsync(user);
}
```

### Admin-Only Endpoint

```csharp
[Function("DeleteUser")]
public async Task<HttpResponseData> DeleteUser(HttpRequestData req, Guid userId)
{
    // Require Administrator role
    var auth = _authService.ValidateAndAuthorize(req, "Administrator");
    if (!auth.IsAuthorized)
        return auth.ErrorResponse!;
    
    await _db.Users.Where(u => u.UserId == userId).ExecuteDeleteAsync();
    return req.CreateResponse(HttpStatusCode.NoContent);
}
```

### Multiple Roles (Any One)

```csharp
// Allow Admin OR Tutor OR Content Creator
var auth = _authService.ValidateAndAuthorize(req, "Administrator", "Tutors", "Content Creator");
if (!auth.IsAuthorized)
    return auth.ErrorResponse!;
```

## 🏗️ Architecture Pattern

The system follows the **Service Layer Pattern**:

```
┌─────────────────────┐
│  AuthFunctions      │  ← Thin HTTP controllers (10-15 lines per endpoint)
│  (HTTP Layer)       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ AuthenticationSvc   │  ← Business logic (validation, orchestration)
│ (Business Layer)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│ TokenService | PasswordService | DbContext │  ← Infrastructure
└─────────────────────────────────────────┘
```

### Benefits:
- ✅ Clear separation of concerns
- ✅ Easy to test independently
- ✅ Reusable across contexts
- ✅ Consistent error handling
- ✅ No HTTP concerns in business logic

## 📖 Documentation

For detailed information, see the documentation files:

1. **AUTHENTICATION_FLOW.md** - Complete authentication flow with diagrams
2. **AUTHENTICATION_SERVICE_ARCHITECTURE.md** - Architecture explanation
3. **AUTHORIZATION_SERVICE_GUIDE.md** - How to use AuthorizationService

## 🔧 Customization

### Update Namespace
Change `ServiceAPI` to your project namespace in all files:
- `ServiceAPI.Common.Services` → `YourProject.Common.Services`
- `ServiceAPI.Domain.Dtos` → `YourProject.Domain.Dtos`
- etc.

### Update DbContext
Replace `LmsDbContext` with your DbContext name.

### Update Roles
Modify the roles in `AuthorizationService.cs` to match your system:
- IsAdministrator
- IsTutor
- IsStudent
- IsParent
- IsContentCreator

### Update Validation Rules
Modify validation in `AuthenticationService.cs`:
- Password strength requirements
- Email format validation
- Gender enum values
- Required fields

## 🚨 Security Considerations

### Production Checklist
- [ ] Move JWT secret to Azure Key Vault
- [ ] Use HTTPS for all endpoints
- [ ] Implement rate limiting on auth endpoints
- [ ] Add account lockout after failed attempts
- [ ] Implement refresh token mechanism
- [ ] Add email verification flow
- [ ] Implement password reset with tokens
- [ ] Add audit logging for security events
- [ ] Consider multi-factor authentication (MFA)
- [ ] Implement CAPTCHA for registration/login
- [ ] Add password complexity requirements
- [ ] Implement password history
- [ ] Monitor for suspicious activities

### Secret Management (Production)

```json
{
  "Jwt": {
    "SecretKey": "@Microsoft.KeyVault(SecretUri=https://your-keyvault.vault.azure.net/secrets/jwt-secret)",
    "Issuer": "https://api.yourapp.com",
    "Audience": "https://yourapp.com",
    "ExpirationHours": 24
  }
}
```

## 📝 License

These files are part of the LMS project. Adjust according to your project's license.

## 🤝 Support

For questions about implementation, refer to the documentation files or review the original LMS project.

---

**Last Updated:** November 27, 2025  
**Version:** 1.0  
**Original Project:** LMS (Learning Management System)
