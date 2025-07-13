using ClimbLog.Domain.Models.SpResponses;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using ClimbLog.Domain.Interfaces;
using System.Data;

namespace ClimbLog.Infrastructure.Repositories;
public class StoredProceduresRepository(ClimbLogContext dbContext) : IStoredProceduresRepository
{
    private readonly DateTime Sunday = DateTime.Today.AddDays(-(int)DateTime.Today.DayOfWeek);
    public async Task<List<GetAllCurentRoutesByGymAndUserSpResponse>> GetAllCurrentRoutesByGymAndUser(string gymName, int loginId)
    {
        // Define parameters
        var loginIdParam = new SqlParameter("@p_LoginId", loginId);
        var gymNameParam = new SqlParameter("@p_GymName", gymName);

        // Call the stored procedure
        var routes = await dbContext.GetAllCurentRoutesByGymAndUser
            .FromSqlRaw("EXEC GetAllCurrentRoutesByGymAndUser @p_LoginId, @p_GymName", loginIdParam, gymNameParam)
            .ToListAsync();

        return routes;
    }

    public async Task<GetPointsAndAscentsSpResponse> GetPointsAndAscents(string gymName, int loginId)
    {
        var loginIdParam = new SqlParameter("@p_LoginId", loginId);
        var gymNameParam = new SqlParameter("@p_GymName", gymName);
        var startDateParam = new SqlParameter("@p_DateStart", Sunday.ToString("yyyy-MM-dd"));

        var response = await dbContext.GetPointsAndAscents
            .FromSqlRaw("EXEC GetPointsAndAscents @p_GymName, @p_LoginId, @p_DateStart"
                , gymNameParam, loginIdParam, startDateParam)
            .ToListAsync();

        var result = response.Single();

        return result;
    }

    public async Task<List<GetAscentsGroupedByGradeSpResponse>> GetAscentsGroupByName(string gymName, int loginId, bool justLastWeek)
    {
        var loginIdParam = new SqlParameter("@p_LoginId", loginId);
        var gymNameParam = new SqlParameter("@p_GymName", gymName);
        var ignoreDateFilterParam = new SqlParameter("@p_IgnoreDateFilter", !justLastWeek);
        var startDateParam = new SqlParameter("@p_DateStart", Sunday.ToString("yyyy-MM-dd"));

        var result = await dbContext.GetAscentsGroupedByGrade
            .FromSqlRaw("EXEC GetAscentsGroupedByGrade @p_GymName, @p_DateStart, @p_IgnoreDateFilter, @p_LoginId",
                gymNameParam, startDateParam, ignoreDateFilterParam, loginIdParam)
            .ToListAsync();

        return result;
    }

    public async Task<int?> GetCompetitionGroupByRouteIdAndLoginId(int routeId, int loginId)
    {
        var routeIdParam = new SqlParameter("@p_RouteId", routeId);
        var loginIdParam = new SqlParameter("@p_LoginId", loginId);
        

        var response = await dbContext.GetCompetitionGroupByRouteIdAndLoginId
            .FromSqlRaw("EXEC GetCompetitionGroupByRouteIdAndLoginId @p_RouteId, @p_LoginId",
                routeIdParam, loginIdParam)
            .ToListAsync();

        var result = response.Select(x => (int?)x.Id).SingleOrDefault();

        return result;
    }

    public async Task<List<GetCompetitionLeaderboardByCompetitionGroupIdSpResponse>> GetCompetitionLeaderboardByCompetitionGroupId(int competitionGroupId)
    {
        var competitionGroupIdParam = new SqlParameter("@p_CompetitionGroupId", competitionGroupId);


        var result = await dbContext.GetCompetitionLeaderboardByCompetitionGroupId
            .FromSqlRaw("EXEC GetCompetitionLeaderboardByCompetitionGroupId @p_CompetitionGroupId",
                competitionGroupIdParam)
            .ToListAsync();

        return result;
    }

    public async Task DeleteLoginByUsername(string username)
    {
        var loginIdParam = new SqlParameter("@p_Username", username);

        await dbContext.Database.ExecuteSqlRawAsync("EXEC DeleteLogin @p_Username", loginIdParam);
    }

    public async Task<List<GetAscentsGroupedByGradeByDateSpResponse>> GetAscentsGroupedByGradeByDate(string gymName, int loginId)
    {
        var loginIdParam = new SqlParameter("@p_LoginId", loginId);
        var gymNameParam = new SqlParameter("@p_GymName", gymName);

        var result = await dbContext.GetAscentsGroupedByGradeByDate
            .FromSqlRaw("EXEC GetAscentsGroupedByGradeByDate @p_LoginId, @p_GymName",
                loginIdParam, gymNameParam)
            .ToListAsync();

        return result;
    }

    public async Task<List<string>> GetPushNotificationTokensByGymName(string gymName)
    {
        var gymNameParam = new SqlParameter("@p_GymName", gymName);

        var spResponse = await dbContext.GetPushNotificationTokensByGymName
            .FromSqlRaw("EXEC GetPushNotificationTokensByGymName @p_GymName",
                gymNameParam)
            .ToListAsync();

        var result = spResponse.Select(x => x.PushNotificationToken).ToList();

        return result;
    }
}
