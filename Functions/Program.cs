using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Middleware;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Quizz.DataAccess;
using Quizz.Auth;
using System;
using System.Threading.Tasks;
using Microsoft.Azure.Functions.Worker.Http;

namespace Quizz.Functions
{
    public class Program
    {
        public static void Main()
        {
            var host = new HostBuilder()
                .ConfigureFunctionsWorkerDefaults(app =>
                {
                    // Add CORS middleware
                    app.UseMiddleware<CorsMiddleware>();
                })
                .ConfigureServices((context, services) =>
                {
                    // Get configuration
                    var configuration = context.Configuration;
                    var connectionString = configuration["PostgresConnectionString"] 
                        ?? Environment.GetEnvironmentVariable("PostgresConnectionString");

                    if (string.IsNullOrEmpty(connectionString))
                    {
                        throw new InvalidOperationException(
                            "PostgresConnectionString not found in configuration. " +
                            "Set it in local.settings.json or Azure App Settings.");
                    }

                    // Register application services
                    services.AddDbService(connectionString);
                    services.AddApiKeyAuthentication();

                    // Register AuthService for JWT authentication
                    services.AddSingleton<Quizz.Auth.AuthService>();

                    // Add application insights (optional)
                    services.AddApplicationInsightsTelemetryWorkerService();
                    services.ConfigureFunctionsApplicationInsights();
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
                    response.Headers.Add("Access-Control-Allow-Origin", "https://black-bush-0d3fb621e.3.azurestaticapps.net");
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
