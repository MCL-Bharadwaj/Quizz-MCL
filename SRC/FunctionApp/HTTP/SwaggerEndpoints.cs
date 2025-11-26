using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Abstractions;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Visitors;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using Microsoft.OpenApi.Writers;
using Newtonsoft.Json;
using System.Net;
using System.Reflection;
using Quizz.Configuration;

namespace Quizz.Functions.HTTP
{
    /// <summary>
    /// HTTP endpoints for Swagger UI and OpenAPI documentation
    /// Uses OpenApiAuthConfiguration for JWT Bearer authentication
    /// </summary>
    public class SwaggerEndpoints
    {
        private readonly ILogger<SwaggerEndpoints> _logger;

        public SwaggerEndpoints(ILogger<SwaggerEndpoints> logger)
        {
            _logger = logger;
        }

        /// <summary>
        /// Renders the Swagger UI interface
        /// </summary>
        [Function("SwaggerUI")]
        [OpenApiIgnore] // Don't show this endpoint in swagger itself
        public async Task<HttpResponseData> RenderSwaggerUI(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "swagger/ui")] HttpRequestData req)
        {
            _logger.LogInformation("Rendering Swagger UI");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/html; charset=utf-8");

            var html = @"<!DOCTYPE html>
<html lang=""en"">
<head>
    <meta charset=""UTF-8"">
    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
    <title>LMS API - Swagger UI</title>
    <link rel=""stylesheet"" href=""https://unpkg.com/swagger-ui-dist@5.10.0/swagger-ui.css"">
    <style>
        body { margin: 0; padding: 0; }
        .swagger-ui .topbar { display: none; }
    </style>
</head>
<body>
    <div id=""swagger-ui""></div>
    <script src=""https://unpkg.com/swagger-ui-dist@5.10.0/swagger-ui-bundle.js""></script>
    <script src=""https://unpkg.com/swagger-ui-dist@5.10.0/swagger-ui-standalone-preset.js""></script>
    <script>
        window.onload = function() {
            window.ui = SwaggerUIBundle({
                url: '/api/swagger.json',
                dom_id: '#swagger-ui',
                deepLinking: true,
                presets: [
                    SwaggerUIBundle.presets.apis,
                    SwaggerUIStandalonePreset
                ],
                plugins: [
                    SwaggerUIBundle.plugins.DownloadUrl
                ],
                layout: 'StandaloneLayout',
                persistAuthorization: true
            });
        };
    </script>
</body>
</html>";

            await response.WriteStringAsync(html);
            return response;
        }

        /// <summary>
        /// Returns the OpenAPI/Swagger JSON specification
        /// Configuration from OpenApiAuthConfiguration
        /// </summary>
        [Function("SwaggerJSON")]
        [OpenApiIgnore] // Don't show this endpoint in swagger itself
        public HttpResponseData RenderSwaggerJSON(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "swagger.json")] HttpRequestData req)
        {
            _logger.LogInformation("Generating OpenAPI JSON using OpenApiAuthConfiguration");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "application/json; charset=utf-8");

            try
            {
                // Create OpenAPI document manually
                var config = new OpenApiAuthConfiguration();
                var openApiDoc = new OpenApiDocument
                {
                    Info = config.Info,
                    Servers = config.Servers,
                    Paths = new OpenApiPaths(),
                    Components = new OpenApiComponents
                    {
                        SecuritySchemes = new Dictionary<string, OpenApiSecurityScheme>
                        {
                            ["bearer_auth"] = new OpenApiSecurityScheme
                            {
                                Type = SecuritySchemeType.Http,
                                Scheme = "bearer",
                                BearerFormat = "JWT",
                                Description = "JWT Authorization header using the Bearer scheme. Enter 'Bearer' [space] and then your token in the text input below.",
                                In = ParameterLocation.Header,
                                Name = "Authorization"
                            }
                        }
                    }
                };

                // Serialize to JSON
                using var stringWriter = new StringWriter();
                var jsonWriter = new OpenApiJsonWriter(stringWriter);
                openApiDoc.SerializeAsV3(jsonWriter);
                var json = stringWriter.ToString();
                response.WriteString(json);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error generating OpenAPI document");
                response.WriteString($"{{\"error\": \"{ex.Message}\"}}");
            }

            return response;
        }

        /// <summary>
        /// Redirect from /api to /api/swagger/ui
        /// </summary>
        [Function("SwaggerRedirect")]
        [OpenApiIgnore]
        public HttpResponseData SwaggerRedirect(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "")] HttpRequestData req)
        {
            _logger.LogInformation("Redirecting to Swagger UI");

            var response = req.CreateResponse(HttpStatusCode.Redirect);
            response.Headers.Add("Location", "/api/swagger/ui");
            return response;
        }
    }
}
