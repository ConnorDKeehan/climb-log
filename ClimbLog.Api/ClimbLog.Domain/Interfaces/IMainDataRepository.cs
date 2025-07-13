using ClimbLog.Domain.Models.Views;

namespace ClimbLog.Domain.Interfaces
{
    public interface IMainDataRepository
    {
        Task<List<vwMainData>> GetMainDataByGymNameAndLoginId(string gymName, int loginId);
        Task<List<vwMainData>> GetMainDataByGymNameForCurrentWeek(string gymName);
    }
}