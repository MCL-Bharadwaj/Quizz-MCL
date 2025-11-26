# Prompt to Recreate Authentication System in Another Project

Copy and paste this prompt to an AI assistant (like GitHub Copilot, ChatGPT, etc.) to recreate this authentication system in your new project:

---

## The Prompt

```
I need to implement a complete JWT-based authentication and authorization system in my Azure Functions .NET 8 project. Please create all the necessary files based on the following specifications:

### Project Requirements
- .NET 8.0
- Azure Functions v4 (Isolated Worker Model)
- Entity Framework Core 8.0
- PostgreSQL database (or SQL Server - adjust as needed)
- OpenAPI/Swagger documentation

### Architecture Pattern
Use the Service Layer Pattern with clear separation:
- HTTP Layer (thin controllers)
- Business Logic Layer (services)
- Data Access Layer (Entity Framework)
- Utilities Layer (helpers)

### Files to Create

#### 1. Common/Services/AuthenticationService.cs
Create a service class for authentication business logic with these methods:
- `LoginAsync(email, password)` → Returns `LoginResult`
- `RegisterAsync(dto)` → Returns `RegisterResult`
- `ChangePasswordAsync(userId, currentPassword, newPassword)` → Returns `ChangePasswordResult`
- `VerifyEmailAsync(email, token)` → Returns `VerifyEmailResult`
- `RequestPasswordResetAsync(email)` → Returns `bool`
- `ResetPasswordAsync(email, token, newPassword)` → Returns `ChangePasswordResult`

Include these result classes in the same file:
- `LoginResult` with properties: Success, Token, UserId, Email, FirstName, LastName, Roles, ErrorMessage
- `RegisterResult` with same properties as LoginResult
- `ChangePasswordResult` with properties: Success, ErrorMessage
- `VerifyEmailResult` with properties: Success, ErrorMessage

Business logic should include:
- Email format validation
- Password strength validation (min 8 characters)
- Check for duplicate email on registration
- BCrypt password hashing (salt round 12)
- Password verification using BCrypt
- Account active status check
- Last login timestamp update
- Role loading from database (active roles only)
- JWT token generation after successful auth

#### 2. Common/Services/AuthorizationService.cs
Create a service for JWT validation and authorization with:
- `ValidateAndAuthorize(req, requiredRoles...)` → Check token and require ANY of the roles
- `ValidateToken(req)` → Just validate token without role check
- `ValidateAndRequireAllRoles(req, requiredRoles...)` → Require ALL specified roles

Return type: `AuthResult` class with:
- Properties: UserId, Roles, ErrorResponse, IsAuthorized
- Boolean helpers: IsAdministrator, IsTutor, IsStudent, IsParent, IsContentCreator
- Methods: HasAnyRole(roles...), HasAllRoles(roles...)

Extract token from "Authorization: Bearer {token}" header.
Return appropriate HTTP error responses (401 Unauthorized, 403 Forbidden).

#### 3. Common/Services/TokenService.cs
Create a service for JWT token operations:
- Constructor: `TokenService(secretKey, issuer, audience, expirationHours)`
- `GenerateToken(userId, email, roles)` → Returns JWT string
- `ValidateToken(token)` → Returns Guid? (userId or null)
- `ValidateTokenWithRoles(token)` → Returns (Guid? UserId, List<string> Roles)

Use:
- SymmetricSecurityKey with HMAC-SHA256
- Claims: sub (userId), email, jti (token ID), userId, role (one claim per role)
- Validation: signature, issuer, audience, lifetime, no clock skew

#### 4. Common/Utilities/PasswordService.cs
Create a static utility class:
- `HashPassword(password)` → BCrypt hash with salt round 12
- `VerifyPassword(password, hash)` → Boolean verification

#### 5. Common/Utilities/JsonConverters.cs
Create two JSON converters:
- `TimeOnlyJsonConverter` - Format: "HH:mm:ss"
- `DateOnlyJsonConverter` - Format: "yyyy-MM-dd"

#### 6. Common/Extensions/Results.cs
Create HTTP response extension methods for `HttpRequestData`:
- `OkAsync(data)` → 200 OK
- `CreatedAsync(location, data)` → 201 Created
- `NoContentAsync()` → 204 No Content
- `BadRequestAsync(detail, errors)` → 400 Bad Request with ProblemDetails
- `UnauthorizedAsync(detail)` → 401 Unauthorized with ProblemDetails
- `ForbiddenAsync(detail)` → 403 Forbidden with ProblemDetails
- `NotFoundAsync(detail)` → 404 Not Found with ProblemDetails
- `ConflictAsync(detail)` → 409 Conflict with ProblemDetails
- `InternalServerErrorAsync(detail)` → 500 Internal Server Error with ProblemDetails

Include `ProblemDetails` class (RFC 7807):
- Properties: Type, Title, Status, Detail, Instance, Extensions

#### 7. Domain/Dtos/UserDtos.cs
Create record DTOs:
- `UserRegisterDto(Email, Password, FirstName, MiddleName, LastName, Phone, DateOfBirth, Gender, Address1, Address2, City, State, Country, PostalCode)`
- `UserLoginDto(Email, Password)`
- `AuthResponseDto(UserId, Email, FirstName, LastName, Token, Roles)`
- `UserDto` - Full user profile with all fields and roles
- `UserUpdateDto` - For updating user profiles
- `ChangePasswordDto(CurrentPassword, NewPassword)`
- `ForgotPasswordDto(Email)`
- `ResetPasswordDto(Email, Token, NewPassword)`
- `VerifyEmailDto(Email, Token)`
- `AssignRoleDto(RoleId)`

#### 8. Configuration/AppOptions.cs
Create configuration classes:
- `JwtOptions` with properties: SecretKey, Issuer, Audience, ExpirationHours
- `DbOptions` with property: ConnectionString
- `CorsOptions` with property: AllowedOrigins
- `OpenApiOptions` with properties: Title, Version, Description

#### 9. Configuration/OpenApiAuthConfiguration.cs
Create OpenAPI configuration class inheriting from `DefaultOpenApiConfigurationOptions`:
- Override Info property with API title, version, description, contact
- Override OpenApiVersion (V3)
- Override Servers list (localhost and production)
- Configure JWT Bearer authentication scheme

#### 10. HTTP/AuthFunctions.cs
Create Azure Functions class with constructor injecting `AuthenticationService`.
Create these HTTP-triggered functions:
- `Register` - POST /v1/auth/register - Anonymous access
- `Login` - POST /v1/auth/login - Anonymous access
- `ChangePassword` - POST /v1/auth/change-password/{userId} - Anonymous (should validate token in production)
- `ForgotPassword` - POST /v1/auth/forgot-password - Anonymous
- `ResetPassword` - POST /v1/auth/reset-password - Anonymous
- `VerifyEmail` - POST /v1/auth/verify-email - Anonymous

Each function should:
- Deserialize request body to appropriate DTO
- Call the corresponding AuthenticationService method
- Map result to AuthResponseDto or error response
- Return appropriate HTTP status code

Add OpenAPI attributes for Swagger documentation.

#### 11. Program.cs Configuration
Add this to your host builder:
```csharp
.ConfigureFunctionsWorkerDefaults(builder =>
{
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
    // Configure options
    services.Configure<JwtOptions>(ctx.Configuration.GetSection("Jwt"));
    services.Configure<DbOptions>(ctx.Configuration.GetSection("Db"));
    
    // DbContext
    var connectionString = ctx.Configuration["Db:ConnectionString"];
    services.AddDbContext<YourDbContext>(opt =>
        opt.UseNpgsql(connectionString));
    
    // Register services
    services.AddSingleton<TokenService>(sp =>
    {
        var jwtConfig = ctx.Configuration.GetSection("Jwt");
        return new TokenService(
            jwtConfig["SecretKey"] ?? "fallback-key",
            jwtConfig["Issuer"] ?? "API",
            jwtConfig["Audience"] ?? "Users",
            int.Parse(jwtConfig["ExpirationHours"] ?? "24")
        );
    });
    
    services.AddScoped<AuthenticationService>();
    services.AddScoped<AuthorizationService>();
})
```

### NuGet Packages Required
```xml
<PackageReference Include="BCrypt.Net-Next" Version="4.0.3" />
<PackageReference Include="Microsoft.IdentityModel.Tokens" Version="8.14.0" />
<PackageReference Include="System.IdentityModel.Tokens.Jwt" Version="8.14.0" />
<PackageReference Include="Microsoft.Azure.Functions.Worker" Version="1.21.0" />
<PackageReference Include="Microsoft.Azure.Functions.Worker.Extensions.Http" Version="3.1.0" />
<PackageReference Include="Microsoft.Azure.Functions.Worker.Extensions.OpenApi" Version="1.5.1" />
<PackageReference Include="Microsoft.EntityFrameworkCore" Version="8.0.10" />
<PackageReference Include="Npgsql.EntityFrameworkCore.PostgreSQL" Version="8.0.8" />
```

### Database Schema
Create Entity Framework entities for:
- **Users** table: user_id (UUID PK), email (unique), password_hash, first_name, last_name, middle_name, phone, date_of_birth, gender, address fields, profile_picture_url, is_active, is_verified, last_login, created_at, updated_at
- **Roles** table: role_id (UUID PK), role_name (unique), description, is_active, created_at
- **UserRoles** table: user_role_id (UUID PK), user_id (FK), role_id (FK), assigned_by (FK to Users), assigned_at, is_active

Add navigation properties:
- User.UserRoles (collection)
- UserRole.User
- UserRole.Role
- UserRole.AssignedByUser

### Configuration File (appsettings.json)
```json
{
  "Jwt": {
    "SecretKey": "your-super-secret-key-change-this-in-production-min-32-chars!",
    "Issuer": "YourAPI",
    "Audience": "YourUsers",
    "ExpirationHours": 24
  },
  "Db": {
    "ConnectionString": "Host=localhost;Database=yourdb;Username=user;Password=pass"
  }
}
```

### Code Style Requirements
- Use C# 12 features (primary constructors, collection expressions, etc.)
- Enable nullable reference types
- Use record types for DTOs
- Add XML documentation comments on all public members
- Use async/await consistently
- Follow SOLID principles
- Use dependency injection
- Include error handling with try-catch where appropriate
- Use extension methods for clean code
- Add OpenAPI attributes for documentation

### Security Features
- BCrypt password hashing with salt round 12
- JWT tokens with HMAC-SHA256 signing
- 24-hour token expiration (configurable)
- Email format validation
- Password minimum length validation (8 characters)
- Active user status check
- Account deactivation support
- Last login tracking
- Role-based authorization
- Consistent error messages (don't reveal if email exists)

### Namespace
Use `YourProject` as the root namespace and adjust for:
- YourProject.Common.Services
- YourProject.Common.Utilities
- YourProject.Common.Extensions
- YourProject.Configuration
- YourProject.Domain.Dtos
- YourProject.HTTP

Please create all these files with complete implementations, proper error handling, and comprehensive XML documentation.
```

---

## Additional Instructions for Your Project

After generating the files, you'll need to:

1. **Update Namespaces**: Replace `YourProject` with your actual project namespace
2. **Update DbContext**: Replace `YourDbContext` with your actual DbContext name
3. **Adjust Database**: If not using PostgreSQL, change to SQL Server or other provider
4. **Configure Roles**: Update role names in AuthorizationService if different
5. **Add Database Migrations**: Run `Add-Migration InitialAuth` and `Update-Database`
6. **Test Endpoints**: Use Swagger UI to test authentication endpoints
7. **Secure JWT Secret**: Move to Azure Key Vault for production

## Testing the Setup

### 1. Register a User
```bash
POST http://localhost:7071/api/v1/auth/register
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "TestPass123!",
  "firstName": "Test",
  "lastName": "User"
}
```

### 2. Login
```bash
POST http://localhost:7071/api/v1/auth/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "TestPass123!"
}
```

### 3. Use Token
```bash
GET http://localhost:7071/api/v1/your-protected-endpoint
Authorization: Bearer <token-from-login>
```

## Troubleshooting

### Common Issues

1. **Token validation fails**: Check JWT secret key length (min 32 chars)
2. **Password hashing fails**: Ensure BCrypt.Net-Next package is installed
3. **Roles not in token**: Verify UserRoles relationship is loaded with `.Include()`
4. **401 errors**: Check Authorization header format: "Bearer {token}"
5. **403 errors**: User doesn't have required role

---

**Note**: This prompt is designed to be comprehensive. You may need to adjust based on your specific project structure and requirements.
