
namespace ClimbLog.Domain.Interfaces;
public interface ICompetitionGroupLoginsRepository
{
    Task Add(int loginId, int competitionGroupId);
    Task DeleteByLoginIdAndCompetitionId(int loginId, int competitionId);
    Task<List<int>> GetCompetitionGroupIdsFromLoginId(int loginId);
}