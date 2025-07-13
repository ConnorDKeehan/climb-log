using ClimbLog.Application.Interfaces;
using ClimbLog.Api.Services;
using Microsoft.Extensions.DependencyInjection;
using AutoMapper;
using ClimbLog.Application.Features.Gym;
using ClimbLog.Application.Features.Competitions;
using ClimbLog.Application.Features.Logins;
using ClimbLog.Application.Features.ClimbLog;
using ClimbLog.Application.Features.Reporting;

namespace ClimbLog.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        var mainAssembly = typeof(DependencyInjection).Assembly;

        services.AddMediatR(cfg =>
            cfg.RegisterServicesFromAssembly(mainAssembly));

        //Putting this here as all the Automappers are in Application proj but may belong in program.cs
        services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

        //Add Services
        services.AddTransient<IDashboardService, DashboardService>();
        services.AddTransient<IS3Service, S3Service>();
        services.AddScoped<IAuthService, AuthService>();
        return services;
    }
}
