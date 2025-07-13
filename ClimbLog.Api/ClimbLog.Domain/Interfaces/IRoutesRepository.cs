using ClimbLog.Domain.Models.Entities;
using ClimbLog.Domain.Models.RepoRequests;

namespace ClimbLog.Domain.Interfaces;

public interface IRoutesRepository
{
    Task<Route> AddRoute(Route route);
    Task ArchiveRoute(int routeId);
    Task ArchiveRoutes(List<int> routeIds);
    Task BulkAlterCompetition(int competitionId, List<int> routeIds);
    Task<Route> GetDetailedRouteById(int routeId);
    Task<Route> GetRouteById(int id);
    Task MoveRoute(int routeId, decimal xCord, decimal yCord);
    Task UpdateRoute(EditRouteRepoRequest request);
}