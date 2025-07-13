using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces
{
    public interface ICompetitionGroupRulesRepository
    {
        Task<CompetitionGroupRule> AddOrGetCompetitionGroupRule(int? numberOfClimbsIncluded);
        Task<CompetitionGroupRule?> GetCompetitionGroupRuleByNumOfClimbs(int? numberOfClimbsIncluded);
    }
}