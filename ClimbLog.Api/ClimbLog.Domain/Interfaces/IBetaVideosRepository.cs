using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces;

public interface IBetaVideosRepository
{
    Task<List<BetaVideo>> GetBetaVideosByRouteId(int routeId);
}
