using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;

namespace ClimbLog.Infrastructure.Repositories;
public class CompetitionGroupRulesRepository(ClimbLogContext dbContext) : ICompetitionGroupRulesRepository
{
    public async Task<CompetitionGroupRule> AddOrGetCompetitionGroupRule(int? numberOfClimbsIncluded)
    {
        var existingResult = await GetCompetitionGroupRuleByNumOfClimbs(numberOfClimbsIncluded);

        if (existingResult != null)
            return existingResult;

        var competitionGroupRule = new CompetitionGroupRule { NumberOfClimbsIncluded = numberOfClimbsIncluded };
        await dbContext.CompetitionGroupRules.AddAsync(competitionGroupRule);
        await dbContext.SaveChangesAsync();

        return competitionGroupRule;
    }

    public async Task<CompetitionGroupRule?> GetCompetitionGroupRuleByNumOfClimbs(int? numberOfClimbsIncluded)
    {
        var result = await dbContext.CompetitionGroupRules
            .Where(x =>
                x.NumberOfClimbsIncluded.HasValue
                && x.NumberOfClimbsIncluded == numberOfClimbsIncluded)
            .FirstOrDefaultAsync();

        return result;
    }
}
