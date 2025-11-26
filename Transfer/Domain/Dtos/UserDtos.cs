namespace ServiceAPI.Domain.Dtos;

// User Registration & Authentication DTOs

/// <summary>
/// DTO for user registration (sign up)
/// </summary>
public record UserRegisterDto(
    string Email,
    string Password,
    string FirstName,
    string? MiddleName,
    string LastName,
    string? Phone,
    DateOnly? DateOfBirth,
    string? Gender,
    string? Address1,
    string? Address2,
    string? City,
    string? State,
    string? Country,
    string? PostalCode
);

/// <summary>
/// DTO for user login
/// </summary>
public record UserLoginDto(
    string Email,
    string Password
);

/// <summary>
/// DTO for authentication response (after successful login/register)
/// </summary>
public record AuthResponseDto(
    Guid UserId,
    string Email,
    string FirstName,
    string LastName,
    string Token,
    List<string> Roles
);

/// <summary>
/// DTO for user profile information (response)
/// </summary>
public record UserDto(
    Guid UserId,
    string Email,
    string FirstName,
    string? MiddleName,
    string LastName,
    string? Phone,
    DateOnly? DateOfBirth,
    string? Gender,
    string? Address1,
    string? Address2,
    string? City,
    string? State,
    string? Country,
    string? PostalCode,
    string? ProfilePictureUrl,
    bool IsActive,
    bool IsVerified,
    DateTimeOffset? LastLogin,
    DateTimeOffset CreatedAt,
    List<string> Roles
);

/// <summary>
/// DTO for updating user profile
/// </summary>
public record UserUpdateDto(
    string? FirstName,
    string? MiddleName,
    string? LastName,
    string? Phone,
    DateOnly? DateOfBirth,
    string? Gender,
    string? Address1,
    string? Address2,
    string? City,
    string? State,
    string? Country,
    string? PostalCode,
    string? ProfilePictureUrl,
    bool? IsActive,
    bool? IsVerified
);

/// <summary>
/// DTO for changing password
/// </summary>
public record ChangePasswordDto(
    string CurrentPassword,
    string NewPassword
);

/// <summary>
/// DTO for forgot password request
/// </summary>
public record ForgotPasswordDto(
    string Email
);

/// <summary>
/// DTO for reset password (with token)
/// </summary>
public record ResetPasswordDto(
    string Email,
    string Token,
    string NewPassword
);

/// <summary>
/// DTO for email verification
/// </summary>
public record VerifyEmailDto(
    string Email,
    string Token
);

/// <summary>
/// DTO for assigning roles to a user
/// </summary>
public record AssignRoleDto(
    Guid RoleId
);
