using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces;
public interface ICompetitionGroupsRepository
{
    Task<List<CompetitionGroup>> GetCompetitionGroupsByCompetitionId(int competitionId);
    Task<CompetitionGroup?> GetCompetitionGroupsByCompIdAndLoginId(int competitionId, int loginId);
}