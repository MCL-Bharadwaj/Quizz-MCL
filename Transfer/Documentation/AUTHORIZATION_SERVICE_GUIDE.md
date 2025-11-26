# AuthorizationService Usage Guide

## Overview
The `AuthorizationService` provides centralized JWT token validation and role-based authorization for all API endpoints. It extracts roles directly from JWT token claims (no database lookup) for maximum performance.

## Available Roles
Based on your database, the following roles are supported:
- **Administrator** - System administrators with full access
- **Tutors** - Teachers/Tutors conducting classes  
- **Student** - Students enrolled in classes
- **Parent** - Parents/Guardians of students
- **Content Creator** - Users who create and manage program content

## Quick Start

### 1. Inject AuthorizationService
```csharp
public class MyFunctions
{
    private readonly LmsDbContext _db;
    private readonly AuthorizationService _authService;

    public MyFunctions(LmsDbContext db, AuthorizationService authService)
    {
        _db = db;
        _authService = authService;
    }
}
```

### 2. Validate and Authorize (Most Common)
Check token validity AND require specific role(s):

```csharp
[Function("CreateProgram")]
public async Task<HttpResponseData> CreateProgram(HttpRequestData req)
{
    // Validate token and require Administrator role
    var auth = _authService.ValidateAndAuthorize(req, "Administrator");
    if (!auth.IsAuthorized)
        return auth.ErrorResponse!;
    
    // Access user info
    var userId = auth.UserId!.Value;
    var userRoles = auth.Roles;
    
    // Your business logic here...
}
```

### 3. Multiple Roles (Any One)
User needs at least ONE of the specified roles:

```csharp
// Allow Admin OR Tutor OR Content Creator
var auth = _authService.ValidateAndAuthorize(req, "Administrator", "Tutors", "Content Creator");
if (!auth.IsAuthorized)
    return auth.ErrorResponse!;
```

### 4. Require ALL Roles
User must have ALL specified roles:

```csharp
// User must have BOTH Administrator AND Content Creator roles
var auth = _authService.ValidateAndRequireAllRoles(req, "Administrator", "Content Creator");
if (!auth.IsAuthorized)
    return auth.ErrorResponse!;
```

### 5. Just Validate Token (No Role Check)
For endpoints that require authentication but any role is acceptable:

```csharp
// Just validate token, don't check roles
var auth = _authService.ValidateToken(req);
if (!auth.IsAuthorized)
    return auth.ErrorResponse!;

// Now you can check roles manually if needed
if (auth.IsAdministrator)
{
    // Admin-specific logic
}
```

## AuthResult Properties

### Boolean Role Checks
```csharp
var auth = _authService.ValidateToken(req);

// Convenient role checks
if (auth.IsAdministrator) { /* ... */ }
if (auth.IsTutor) { /* ... */ }
if (auth.IsStudent) { /* ... */ }
if (auth.IsParent) { /* ... */ }
if (auth.IsContentCreator) { /* ... */ }
```

### Advanced Role Checks
```csharp
// Check if user has ANY of the roles
if (auth.HasAnyRole("Administrator", "Tutors"))
{
    // User is either Admin or Tutor
}

// Check if user has ALL roles
if (auth.HasAllRoles("Tutors", "Content Creator"))
{
    // User is both Tutor AND Content Creator
}
```

### Access User Info
```csharp
var auth = _authService.ValidateToken(req);
if (auth.IsAuthorized)
{
    Guid userId = auth.UserId!.Value;
    List<string> roles = auth.Roles;
    
    Console.WriteLine($"User {userId} has roles: {string.Join(", ", roles)}");
}
```

## Common Patterns

### Pattern 1: Admin-Only Endpoint
```csharp
[Function("DeleteUser")]
public async Task<HttpResponseData> DeleteUser(HttpRequestData req, Guid userId)
{
    var auth = _authService.ValidateAndAuthorize(req, "Administrator");
    if (!auth.IsAuthorized)
        return auth.ErrorResponse!;
    
    // Only admins can delete users
    await _db.Users.Where(u => u.UserId == userId).ExecuteDeleteAsync();
    return req.CreateResponse(HttpStatusCode.NoContent);
}
```

### Pattern 2: Admin or Owner
```csharp
[Function("UpdateProfile")]
public async Task<HttpResponseData> UpdateProfile(HttpRequestData req, Guid userId)
{
    var auth = _authService.ValidateToken(req);
    if (!auth.IsAuthorized)
        return auth.ErrorResponse!;
    
    // Allow if user is admin OR updating their own profile
    if (!auth.IsAdministrator && auth.UserId != userId)
    {
        var forbidden = req.CreateResponse(HttpStatusCode.Forbidden);
        await forbidden.WriteAsJsonAsync(new ProblemDetails
        {
            Status = 403,
            Title = "Access denied",
            Detail = "You can only update your own profile"
        });
        return forbidden;
    }
    
    // Update logic...
}
```

### Pattern 3: Different Logic per Role
```csharp
[Function("GetDashboard")]
public async Task<HttpResponseData> GetDashboard(HttpRequestData req)
{
    var auth = _authService.ValidateToken(req);
    if (!auth.IsAuthorized)
        return auth.ErrorResponse!;
    
    object dashboardData;
    
    if (auth.IsAdministrator)
    {
        dashboardData = await GetAdminDashboard();
    }
    else if (auth.IsTutor)
    {
        dashboardData = await GetTutorDashboard(auth.UserId!.Value);
    }
    else if (auth.IsStudent)
    {
        dashboardData = await GetStudentDashboard(auth.UserId!.Value);
    }
    else
    {
        return req.CreateResponse(HttpStatusCode.Forbidden);
    }
    
    var response = req.CreateResponse(HttpStatusCode.OK);
    await response.WriteAsJsonAsync(dashboardData);
    return response;
}
```

## Error Responses

The AuthorizationService returns standard HTTP error responses:

### 401 Unauthorized
Returned when:
- Authorization header is missing
- Token is malformed or empty
- Token signature is invalid
- Token has expired

```json
{
  "status": 401,
  "title": "Unauthorized",
  "detail": "Invalid or expired token"
}
```

### 403 Forbidden
Returned when:
- Token is valid but user doesn't have required role(s)

```json
{
  "status": 403,
  "title": "Access denied",
  "detail": "This operation requires one of the following roles: Administrator"
}
```

## Performance Notes

- ✅ **No database queries** - Roles extracted from JWT token claims
- ✅ **Fast validation** - Just cryptographic signature verification
- ✅ **Stateless** - No session lookup required
- ⚠️ **Role changes take 24 hours** - Roles are frozen until token expires (configurable)

## Security Best Practices

1. **Always validate on protected endpoints**
   ```csharp
   // ❌ Bad - No validation
   public async Task<HttpResponseData> DeleteUser(HttpRequestData req)
   {
       // Anyone can call this!
   }
   
   // ✅ Good - Validated
   public async Task<HttpResponseData> DeleteUser(HttpRequestData req)
   {
       var auth = _authService.ValidateAndAuthorize(req, "Administrator");
       if (!auth.IsAuthorized) return auth.ErrorResponse!;
       // Only admins can call this
   }
   ```

2. **Use specific roles, not "any authenticated user"**
   ```csharp
   // ⚠️ Less secure - any valid token works
   var auth = _authService.ValidateToken(req);
   
   // ✅ Better - specific role required
   var auth = _authService.ValidateAndAuthorize(req, "Administrator");
   ```

3. **Check ownership when appropriate**
   ```csharp
   // ✅ Good - verify user owns the resource or is admin
   if (!auth.IsAdministrator && resource.OwnerId != auth.UserId)
   {
       return Forbidden();
   }
   ```

## Migration from Old Code

### Before (Manual validation):
```csharp
public class ProgramFunctions
{
    private readonly TokenService _tokenService;
    
    private (Guid?, List<string>, HttpResponseData?) ValidateTokenFromClaims(HttpRequestData req)
    {
        // 40+ lines of token extraction and validation...
    }
    
    public async Task<HttpResponseData> CreateProgram(HttpRequestData req)
    {
        var (userId, roles, error) = ValidateTokenFromClaims(req);
        if (error != null) return error;
        
        if (!roles.Contains("Administrator"))
        {
            // Create forbidden response...
        }
        // Business logic...
    }
}
```

### After (AuthorizationService):
```csharp
public class ProgramFunctions
{
    private readonly AuthorizationService _authService;
    
    public async Task<HttpResponseData> CreateProgram(HttpRequestData req)
    {
        var auth = _authService.ValidateAndAuthorize(req, "Administrator");
        if (!auth.IsAuthorized) return auth.ErrorResponse!;
        
        // Business logic...
    }
}
```

**Benefits:**
- 90% less code
- Consistent error messages
- Easier to read and maintain
- Same performance (token-only validation)
