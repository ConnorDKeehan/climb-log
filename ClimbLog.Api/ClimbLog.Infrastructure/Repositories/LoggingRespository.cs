using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using FirebaseAdmin.Messaging;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Infrastructure.Repositories;
public class LoggingRespository(IHttpContextAccessor httpContextAccessor, IServiceScopeFactory serviceScopeFactory) 
    : ILoggingRespository
{
    public void Log<T>(string message, LogLevel logLevel)
    {
        _ = LogAsync(message, logLevel, typeof(T).Name);
    }

    private async Task LogAsync(string message, LogLevel logLevel, string source)
    {
        using var scope = serviceScopeFactory.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<ClimbLogContext>();

        var loginId = 0;
        try
        {
            loginId = int.Parse(httpContextAccessor.HttpContext?.User!.FindFirstValue("LoginId") ?? "0");
        }
        catch { };

        try
        {
            var climasysApiLog = new ClimasysApiLog
            {
                LoginId = loginId,
                Message = message,
                Level = logLevel.ToString(),
                Source = source
            };

            await dbContext.ClimasysApiLogs.AddAsync(climasysApiLog);
            await dbContext.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Logging failed: {ex.Message}");
        }
    }
}
