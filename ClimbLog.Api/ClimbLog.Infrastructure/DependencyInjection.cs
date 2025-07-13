using ClimbLog.Domain.Interfaces;
using ClimbLog.Infrastructure.Contexts;
using ClimbLog.Infrastructure.Repositories;
using ClimbLog.Infrastructure.Services;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace ClimbLog.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructureServices(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // Register your DbContext
        services.AddDbContext<ClimbLogContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("ClimbLog")));

        //Register repos
        services.AddScoped<IClimbLogsRepository, ClimbLogsRepository>();
        services.AddScoped<IGradesRepository, GradesRepository>();
        services.AddScoped<IGymsRepository, GymsRepository>();
        services.AddScoped<IGymAdminsRepository, GymAdminsRepository>();
        services.AddScoped<ILoginsRepository, LoginsRepository>();
        services.AddScoped<IRoutesRepository, RoutesRepository>();
        services.AddScoped<IStoredProceduresRepository, StoredProceduresRepository>();
        services.AddScoped<IGymFacilitiesRepository, GymFacilitiesRepository>();
        services.AddScoped<IGymDefaultOpeningHoursRepository, GymDefaultOpeningHoursRepository>();
        services.AddScoped<IFacilitiesRepository, FacilitiesRepository>();
        services.AddScoped<ICompetitionsRepository, CompetitionsRepository>();
        services.AddScoped<ICompetitionGroupRulesRepository, CompetitionGroupRulesRepository>();
        services.AddScoped<ICompetitionGroupLoginsRepository, CompetitionGroupLoginsRepository>();
        services.AddScoped<ICompetitionGroupsRepository, CompetitionGroupsRepository>();
        services.AddScoped<IMainDataRepository, MainDataRepository>();
        services.AddScoped<ILoggingRespository, LoggingRespository>();
        services.AddScoped<ISectorsRepository, SectorsRepository>();
        services.AddScoped<IBetaVideosRepository, BetaVideosRepository>();
        services.AddScoped<IDifficultiesForGradeRepository, DifficultiesForGradeRepository>();


        //Register firebaseapp
        FirebaseApp.Create(new AppOptions
        {
            Credential = GoogleCredential.FromFile("firebase.json")
        });

        services.AddScoped<IFirebaseService, FirebaseService>();

        return services;
    }
}
