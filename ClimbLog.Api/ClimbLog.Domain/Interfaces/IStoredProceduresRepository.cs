using ClimbLog.Domain.Models.SpResponses;

namespace ClimbLog.Domain.Interfaces;

public interface IStoredProceduresRepository
{
    Task DeleteLoginByUsername(string username);
    Task<List<GetAllCurentRoutesByGymAndUserSpResponse>> GetAllCurrentRoutesByGymAndUser(string gymName, int loginId);
    Task<List<GetAscentsGroupedByGradeSpResponse>> GetAscentsGroupByName(string gymName, int loginId, bool justLastWeek);
    Task<List<GetAscentsGroupedByGradeByDateSpResponse>> GetAscentsGroupedByGradeByDate(string gymName, int loginId);
    Task<int?> GetCompetitionGroupByRouteIdAndLoginId(int routeId, int loginId);
    Task<List<GetCompetitionLeaderboardByCompetitionGroupIdSpResponse>> GetCompetitionLeaderboardByCompetitionGroupId(int competitionGroupId);
    Task<GetPointsAndAscentsSpResponse> GetPointsAndAscents(string gymName, int loginId);
    Task<List<string>> GetPushNotificationTokensByGymName(string gymName);
}