



namespace ClimbLog.Domain.Interfaces;

public interface IClimbLogsRepository
{
    Task DeleteClimbLog(int routeId, int loginId);
    Task<List<Domain.Models.Entities.ClimbLog>> GetAllClimbLogsByLoginId(int loginId);
    Task<Models.Entities.ClimbLog> GetClimbLogById(int id);
    Task<Models.Entities.ClimbLog?> GetClimbLogByRouteIdAndLoginId(int routeId, int loginId);
    Task<List<Models.Entities.ClimbLog>> GetDetailedClimbLogsByRouteId(int routeId);
    Task LogClimb(Models.Entities.ClimbLog climbLog);
    Task UpdateClimbLog(Models.Entities.ClimbLog climbLog);
}