using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Middleware;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Quizz.DataAccess;
using Quizz.Common.Services;
using System;
using System.Threading.Tasks;
using Microsoft.Azure.Functions.Worker.Http;

namespace Quizz.Functions
{
    // Deployment test - forcing redeploy with proper settings
    public class Program
    {
        public static void Main()
        {
            try
            {
                Console.WriteLine("========================================");
                Console.WriteLine($"[{DateTime.UtcNow}] Starting Quizz Function App...");
                Console.WriteLine($"Environment: {Environment.GetEnvironmentVariable("AZURE_FUNCTIONS_ENVIRONMENT")}");
                Console.WriteLine($"Worker Runtime: {Environment.GetEnvironmentVariable("FUNCTIONS_WORKER_RUNTIME")}");
                Console.WriteLine("========================================");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"ERROR in startup logging: {ex.Message}");
            }

            var host = new HostBuilder()
                .ConfigureFunctionsWorkerDefaults(app =>
                {
                    // Add CORS middleware
                    app.UseMiddleware<CorsMiddleware>();
                })
                .ConfigureServices((context, services) =>
                {
                    try
                    {
                        Console.WriteLine($"[{DateTime.UtcNow}] Configuring services...");
                        
                        // Get configuration
                        var configuration = context.Configuration;
                        Console.WriteLine($"[{DateTime.UtcNow}] Configuration retrieved");
                        
                        var connectionString = configuration["PostgresConnectionString"] 
                            ?? Environment.GetEnvironmentVariable("PostgresConnectionString");

                        Console.WriteLine($"[{DateTime.UtcNow}] Connection string present: {!string.IsNullOrEmpty(connectionString)}");

                        if (string.IsNullOrEmpty(connectionString))
                        {
                            Console.WriteLine($"[{DateTime.UtcNow}] ERROR: PostgresConnectionString not found!");
                            throw new InvalidOperationException(
                                "PostgresConnectionString not found in configuration. " +
                                "Set it in local.settings.json or Azure App Settings.");
                        }

                        // Register application services
                        Console.WriteLine($"[{DateTime.UtcNow}] Registering DbService...");
                        services.AddDbService(connectionString);

                        // Register TokenService for JWT generation
                        Console.WriteLine($"[{DateTime.UtcNow}] Registering TokenService...");
                        var jwtSecret = configuration["Jwt:SecretKey"] 
                            ?? configuration["Jwt__SecretKey"]
                            ?? Environment.GetEnvironmentVariable("Jwt__SecretKey")
                            ?? throw new InvalidOperationException("JWT Secret not configured");
                        services.AddSingleton(new TokenService(jwtSecret));

                        Console.WriteLine($"[{DateTime.UtcNow}] Adding Application Insights...");
                        services.AddApplicationInsightsTelemetryWorkerService();
                        services.ConfigureFunctionsApplicationInsights();
                        
                        Console.WriteLine($"[{DateTime.UtcNow}] Service configuration completed successfully");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"[{DateTime.UtcNow}] FATAL ERROR in ConfigureServices: {ex.GetType().Name}");
                        Console.WriteLine($"Message: {ex.Message}");
                        Console.WriteLine($"Stack: {ex.StackTrace}");
                        throw;
                    }
                })
                .Build();

            host.Run();
        }
    }

    // CORS Middleware for Azure Functions
    public class CorsMiddleware : IFunctionsWorkerMiddleware
    {
        public async Task Invoke(FunctionContext context, FunctionExecutionDelegate next)
        {
            var requestData = await context.GetHttpRequestDataAsync();
            
            if (requestData != null)
            {
                // Get the response
                await next(context);

                // Add CORS headers to response
                var response = context.GetHttpResponseData();
                if (response != null)
                {
                    // Allow your Static Web App domain
                    response.Headers.Add("Access-Control-Allow-Origin", "https://agreeable-sky-055d7961e.3.azurestaticapps.net");
                    response.Headers.Add("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS, PATCH");
                    response.Headers.Add("Access-Control-Allow-Headers", "Content-Type, Authorization, X-API-Key");
                    response.Headers.Add("Access-Control-Allow-Credentials", "true");
                    response.Headers.Add("Access-Control-Max-Age", "86400");
                }
            }
            else
            {
                await next(context);
            }
        }
    }
}
