using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.OpenApi.Models;
using ServiceAPI.Domain.Dtos;
using ServiceAPI.Common.Services;
using ServiceAPI.Common.Utilities;
using ServiceAPI.Common.Extensions;

namespace ServiceAPI.HTTP;

/// <summary>
/// Azure Functions for Authentication operations
/// Handles user registration, login, password reset, and email verification
/// </summary>
public class AuthFunctions
{
    private readonly AuthenticationService _authService;

    public AuthFunctions(AuthenticationService authService)
    {
        _authService = authService;
    }

    #region Authentication

    [Function("Register")]
    [OpenApiOperation(operationId: "Register", tags: new[] { "Authentication" }, Summary = "Register a new user")]
    [OpenApiRequestBody(contentType: "application/json", bodyType: typeof(UserRegisterDto), Required = true)]
    [OpenApiResponseWithBody(statusCode: HttpStatusCode.Created, contentType: "application/json", bodyType: typeof(AuthResponseDto))]
    [OpenApiResponseWithBody(statusCode: HttpStatusCode.BadRequest, contentType: "application/json", bodyType: typeof(string))]
    public async Task<HttpResponseData> Register(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "v1/auth/register")] HttpRequestData req)
    {
        var dto = await req.ReadFromJsonAsync<UserRegisterDto>();
        if (dto == null)
            return await req.BadRequestAsync("Invalid request body");

        // Call authentication service
        var result = await _authService.RegisterAsync(dto);

        if (!result.Success)
            return await req.BadRequestAsync(result.ErrorMessage!);

        var response = new AuthResponseDto(
            result.UserId!.Value,
            result.Email!,
            result.FirstName!,
            result.LastName!,
            result.Token!,
            result.Roles
        );

        var httpResponse = req.CreateResponse(HttpStatusCode.Created);
        await httpResponse.WriteAsJsonAsync(response);
        return httpResponse;
    }

    [Function("Login")]
    [OpenApiOperation(operationId: "Login", tags: new[] { "Authentication" }, Summary = "Login with email and password")]
    [OpenApiRequestBody(contentType: "application/json", bodyType: typeof(UserLoginDto), Required = true)]
    [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "application/json", bodyType: typeof(AuthResponseDto))]
    [OpenApiResponseWithBody(statusCode: HttpStatusCode.Unauthorized, contentType: "application/json", bodyType: typeof(string))]
    public async Task<HttpResponseData> Login(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "v1/auth/login")] HttpRequestData req)
    {
        var dto = await req.ReadFromJsonAsync<UserLoginDto>();
        if (dto == null)
            return await req.BadRequestAsync("Invalid request body");

        // Call authentication service
        var result = await _authService.LoginAsync(dto.Email!, dto.Password!);

        if (!result.Success)
            return await req.UnauthorizedAsync(result.ErrorMessage!);

        var response = new AuthResponseDto(
            result.UserId!.Value,
            result.Email!,
            result.FirstName!,
            result.LastName!,
            result.Token!,
            result.Roles
        );

        return await req.OkAsync(response);
    }

    [Function("ChangePassword")]
    [OpenApiOperation(operationId: "ChangePassword", tags: new[] { "Authentication" }, Summary = "Change user password")]
    [OpenApiParameter(name: "userId", In = ParameterLocation.Path, Type = typeof(Guid), Required = true)]
    [OpenApiRequestBody(contentType: "application/json", bodyType: typeof(ChangePasswordDto), Required = true)]
    [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "application/json", bodyType: typeof(string))]
    public async Task<HttpResponseData> ChangePassword(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "v1/auth/change-password/{userId:guid}")] HttpRequestData req,
        Guid userId)
    {
        var dto = await req.ReadFromJsonAsync<ChangePasswordDto>();
        if (dto == null)
            return await req.BadRequestAsync("Invalid request body");

        // TODO: Get userId from JWT token instead of parameter
        
        // Call authentication service
        var result = await _authService.ChangePasswordAsync(userId, dto.CurrentPassword!, dto.NewPassword!);

        if (!result.Success)
        {
            if (result.ErrorMessage == "User not found")
                return await req.NotFoundAsync(result.ErrorMessage);
            if (result.ErrorMessage == "Current password is incorrect")
                return await req.UnauthorizedAsync(result.ErrorMessage);
            return await req.BadRequestAsync(result.ErrorMessage!);
        }

        return await req.OkAsync("Password changed successfully");
    }

    [Function("ForgotPassword")]
    [OpenApiOperation(operationId: "ForgotPassword", tags: new[] { "Authentication" }, Summary = "Request password reset (sends email with token)")]
    [OpenApiRequestBody(contentType: "application/json", bodyType: typeof(ForgotPasswordDto), Required = true)]
    [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "application/json", bodyType: typeof(string))]
    public async Task<HttpResponseData> ForgotPassword(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "v1/auth/forgot-password")] HttpRequestData req)
    {
        var dto = await req.ReadFromJsonAsync<ForgotPasswordDto>();
        if (dto == null)
            return await req.BadRequestAsync("Invalid request body");

        if (string.IsNullOrEmpty(dto.Email))
            return await req.BadRequestAsync("Email is required");

        // Call authentication service
        await _authService.RequestPasswordResetAsync(dto.Email);

        // Always return success (don't reveal if email exists for security)
        return await req.OkAsync("If an account with that email exists, a password reset link has been sent.");
    }

    [Function("ResetPassword")]
    [OpenApiOperation(operationId: "ResetPassword", tags: new[] { "Authentication" }, Summary = "Reset password using token from email")]
    [OpenApiRequestBody(contentType: "application/json", bodyType: typeof(ResetPasswordDto), Required = true)]
    [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "application/json", bodyType: typeof(string))]
    public async Task<HttpResponseData> ResetPassword(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "v1/auth/reset-password")] HttpRequestData req)
    {
        var dto = await req.ReadFromJsonAsync<ResetPasswordDto>();
        if (dto == null)
            return await req.BadRequestAsync("Invalid request body");

        // Call authentication service
        var result = await _authService.ResetPasswordAsync(dto.Email!, dto.Token!, dto.NewPassword!);

        if (!result.Success)
            return await req.BadRequestAsync(result.ErrorMessage!);

        return await req.OkAsync("Password reset successfully");
    }

    [Function("VerifyEmail")]
    [OpenApiOperation(operationId: "VerifyEmail", tags: new[] { "Authentication" }, Summary = "Verify user email with token")]
    [OpenApiRequestBody(contentType: "application/json", bodyType: typeof(VerifyEmailDto), Required = true)]
    [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "application/json", bodyType: typeof(string))]
    public async Task<HttpResponseData> VerifyEmail(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "v1/auth/verify-email")] HttpRequestData req)
    {
        var dto = await req.ReadFromJsonAsync<VerifyEmailDto>();
        if (dto == null)
            return await req.BadRequestAsync("Invalid request body");

        // Call authentication service
        var result = await _authService.VerifyEmailAsync(dto.Email!, dto.Token!);

        if (!result.Success)
        {
            if (result.ErrorMessage == "User not found")
                return await req.NotFoundAsync(result.ErrorMessage);
            return await req.OkAsync(result.ErrorMessage!); // "Email already verified"
        }

        return await req.OkAsync("Email verified successfully");
    }

    #endregion
}
