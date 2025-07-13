using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces
{
    public interface ICompetitionsRepository
    {
        Task AddCompetition(Competition competition);
        Task<Competition?> GetCompetitionDetailsByName(string name);
        Task<List<Competition>> GetCompetitionsByGymId(int gymId);
        Task<List<Competition>> GetCompetitionsByCompetitionGroupIds(List<int> competitionGroupIds);
        Task UpdateCompetitionActive(int id, bool active);
        Task ArchiveCompetition(int id);
        Task<Competition?> GetActiveCompetitionById(int id);
    }
}