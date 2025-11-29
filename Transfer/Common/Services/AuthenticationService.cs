using Microsoft.EntityFrameworkCore;
using ServiceAPI.Data;
using ServiceAPI.Domain.Dtos;
using ServiceAPI.Domain.Entities;
using ServiceAPI.Common.Utilities;

namespace ServiceAPI.Common.Services;

/// <summary>
/// Result of a login operation
/// </summary>
public class LoginResult
{
    public bool Success { get; set; }
    public string? Token { get; set; }
    public Guid? UserId { get; set; }
    public string? Email { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public List<string> Roles { get; set; } = new();
    public string? ErrorMessage { get; set; }

    public static LoginResult Successful(Guid userId, string email, string firstName, string lastName, string token, List<string> roles)
        => new() { Success = true, UserId = userId, Email = email, FirstName = firstName, LastName = lastName, Token = token, Roles = roles };

    public static LoginResult Failed(string errorMessage)
        => new() { Success = false, ErrorMessage = errorMessage };
}

/// <summary>
/// Result of a registration operation
/// </summary>
public class RegisterResult
{
    public bool Success { get; set; }
    public string? Token { get; set; }
    public Guid? UserId { get; set; }
    public string? Email { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public List<string> Roles { get; set; } = new();
    public string? ErrorMessage { get; set; }

    public static RegisterResult Successful(Guid userId, string email, string firstName, string lastName, string token, List<string> roles)
        => new() { Success = true, UserId = userId, Email = email, FirstName = firstName, LastName = lastName, Token = token, Roles = roles };

    public static RegisterResult Failed(string errorMessage)
        => new() { Success = false, ErrorMessage = errorMessage };
}

/// <summary>
/// Result of a password change operation
/// </summary>
public class ChangePasswordResult
{
    public bool Success { get; set; }
    public string? ErrorMessage { get; set; }

    public static ChangePasswordResult Successful()
        => new() { Success = true };

    public static ChangePasswordResult Failed(string errorMessage)
        => new() { Success = false, ErrorMessage = errorMessage };
}

/// <summary>
/// Result of an email verification operation
/// </summary>
public class VerifyEmailResult
{
    public bool Success { get; set; }
    public string? ErrorMessage { get; set; }

    public static VerifyEmailResult Successful()
        => new() { Success = true };

    public static VerifyEmailResult Failed(string errorMessage)
        => new() { Success = false, ErrorMessage = errorMessage };
}

/// <summary>
/// Service for handling authentication business logic (login, registration, password management)
/// </summary>
public class AuthenticationService
{
    private readonly LmsDbContext _db;
    private readonly TokenService _tokenService;

    public AuthenticationService(LmsDbContext db, TokenService tokenService)
    {
        _db = db;
        _tokenService = tokenService;
    }

    /// <summary>
    /// Authenticates a user with email and password
    /// </summary>
    public async Task<LoginResult> LoginAsync(string email, string password)
    {
        // Validate input
        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            return LoginResult.Failed("Email and password are required");

        // Find user by email
        var user = await _db.Users
            .Include(u => u.UserRoles)
            .ThenInclude(ur => ur.Role)
            .FirstOrDefaultAsync(u => u.Email == email);

        if (user == null)
            return LoginResult.Failed("Invalid email or password");

        // Verify password
        if (!PasswordService.VerifyPassword(password, user.PasswordHash))
            return LoginResult.Failed("Invalid email or password");

        // Check if user is active
        if (!user.IsActive)
            return LoginResult.Failed("Your account has been deactivated. Please contact support.");

        // Update last login
        user.LastLogin = DateTimeOffset.UtcNow;
        await _db.SaveChangesAsync();

        // Get active user roles only
        var roles = user.UserRoles
            .Where(ur => ur.IsActive && ur.Role.IsActive)
            .Select(ur => ur.Role.RoleName)
            .ToList();

        // Generate JWT token
        var token = _tokenService.GenerateToken(user.UserId, user.Email, roles);

        return LoginResult.Successful(user.UserId, user.Email, user.FirstName, user.LastName, token, roles);
    }

    /// <summary>
    /// Registers a new user account
    /// </summary>
    public async Task<RegisterResult> RegisterAsync(UserRegisterDto dto)
    {
        // Validate required fields
        if (string.IsNullOrWhiteSpace(dto.Email))
            return RegisterResult.Failed("Email is required");

        if (string.IsNullOrWhiteSpace(dto.Password))
            return RegisterResult.Failed("Password is required");

        if (string.IsNullOrWhiteSpace(dto.FirstName))
            return RegisterResult.Failed("First name is required");

        if (string.IsNullOrWhiteSpace(dto.LastName))
            return RegisterResult.Failed("Last name is required");

        // Validate email format
        if (!IsValidEmail(dto.Email))
            return RegisterResult.Failed("Invalid email format");

        // Validate password strength
        if (dto.Password.Length < 8)
            return RegisterResult.Failed("Password must be at least 8 characters long");

        // Validate gender if provided
        if (!string.IsNullOrEmpty(dto.Gender))
        {
            var validGenders = new[] { "Male", "Female", "Other", "Prefer not to say" };
            if (!validGenders.Contains(dto.Gender))
                return RegisterResult.Failed($"Gender must be one of: {string.Join(", ", validGenders)}");
        }

        // Check if email already exists
        var existingUser = await _db.Users.FirstOrDefaultAsync(u => u.Email == dto.Email);
        if (existingUser != null)
            return RegisterResult.Failed("A user with this email already exists");

        // Hash the password
        var passwordHash = PasswordService.HashPassword(dto.Password);

        // Create new user
        var user = new User
        {
            Email = dto.Email,
            PasswordHash = passwordHash,
            FirstName = dto.FirstName,
            MiddleName = dto.MiddleName,
            LastName = dto.LastName,
            Phone = dto.Phone,
            DateOfBirth = dto.DateOfBirth,
            Gender = dto.Gender,
            Address1 = dto.Address1,
            Address2 = dto.Address2,
            City = dto.City,
            State = dto.State,
            Country = dto.Country,
            PostalCode = dto.PostalCode,
            IsActive = true,
            IsVerified = false, // Email verification required
            CreatedAt = DateTimeOffset.UtcNow,
            UpdatedAt = DateTimeOffset.UtcNow
        };

        _db.Users.Add(user);
        await _db.SaveChangesAsync();

        // Load user roles with Role entity (filter for active roles only)
        await _db.Entry(user)
            .Collection(u => u.UserRoles)
            .Query()
            .Include(ur => ur.Role)
            .Where(ur => ur.IsActive && ur.Role.IsActive)
            .LoadAsync();

        var roles = user.UserRoles
            .Select(ur => ur.Role.RoleName)
            .ToList();

        // Generate JWT token
        var token = _tokenService.GenerateToken(user.UserId, user.Email, roles);

        return RegisterResult.Successful(user.UserId, user.Email, user.FirstName, user.LastName, token, roles);
    }

    /// <summary>
    /// Changes a user's password (requires current password)
    /// </summary>
    public async Task<ChangePasswordResult> ChangePasswordAsync(Guid userId, string currentPassword, string newPassword)
    {
        // Validate input
        if (string.IsNullOrWhiteSpace(currentPassword) || string.IsNullOrWhiteSpace(newPassword))
            return ChangePasswordResult.Failed("Current password and new password are required");

        if (newPassword.Length < 8)
            return ChangePasswordResult.Failed("New password must be at least 8 characters long");

        // Find user
        var user = await _db.Users.FindAsync(userId);
        if (user == null)
            return ChangePasswordResult.Failed("User not found");

        // Verify current password
        if (!PasswordService.VerifyPassword(currentPassword, user.PasswordHash))
            return ChangePasswordResult.Failed("Current password is incorrect");

        // Hash new password
        user.PasswordHash = PasswordService.HashPassword(newPassword);
        user.UpdatedAt = DateTimeOffset.UtcNow;

        await _db.SaveChangesAsync();

        return ChangePasswordResult.Successful();
    }

    /// <summary>
    /// Verifies a user's email address
    /// </summary>
    public async Task<VerifyEmailResult> VerifyEmailAsync(string email, string token)
    {
        // Validate input
        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(token))
            return VerifyEmailResult.Failed("Email and token are required");

        // TODO: Verify token against stored verification tokens

        // Find user
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == email);
        if (user == null)
            return VerifyEmailResult.Failed("User not found");

        if (user.IsVerified)
            return VerifyEmailResult.Failed("Email already verified");

        user.IsVerified = true;
        user.UpdatedAt = DateTimeOffset.UtcNow;
        await _db.SaveChangesAsync();

        return VerifyEmailResult.Successful();
    }

    /// <summary>
    /// Initiates a password reset request (sends email with token)
    /// </summary>
    public async Task<bool> RequestPasswordResetAsync(string email)
    {
        // Validate input
        if (string.IsNullOrWhiteSpace(email))
            return false;

        var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == email);

        // Always return true (don't reveal if email exists for security)
        // TODO: Generate reset token, store in database, send email
        
        return true;
    }

    /// <summary>
    /// Resets a user's password using a reset token
    /// </summary>
    public async Task<ChangePasswordResult> ResetPasswordAsync(string email, string token, string newPassword)
    {
        // Validate input
        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(token) || string.IsNullOrWhiteSpace(newPassword))
            return ChangePasswordResult.Failed("Email, token, and new password are required");

        if (newPassword.Length < 8)
            return ChangePasswordResult.Failed("New password must be at least 8 characters long");

        // TODO: Verify reset token from database
        // For now, return not implemented
        return ChangePasswordResult.Failed("Password reset functionality not yet implemented. Please use change password after logging in.");
    }

    #region Helper Methods

    private static bool IsValidEmail(string email)
    {
        try
        {
            var addr = new System.Net.Mail.MailAddress(email);
            return addr.Address == email;
        }
        catch
        {
            return false;
        }
    }

    #endregion
}
