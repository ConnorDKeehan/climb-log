using ClimbLog.Api.Responses;

namespace ClimbLog.Application.Interfaces
{
    public interface IDashboardService
    {
        Task<GetPersonalStatsByGymResponse> GetPersonalStatsByGym(string gymName, int loginId);
    }
}