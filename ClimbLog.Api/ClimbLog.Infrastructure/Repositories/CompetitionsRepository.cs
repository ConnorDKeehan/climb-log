using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;

namespace ClimbLog.Infrastructure.Repositories;
public class CompetitionsRepository(ClimbLogContext dbContext) : ICompetitionsRepository
{
    public async Task AddCompetition(Competition competition)
    {
        await dbContext.Competitions.AddAsync(competition);

        await dbContext.SaveChangesAsync();
    }

    public async Task<Competition?> GetCompetitionDetailsByName(string name)
    {
        var result = await dbContext.Competitions
            .Where(x => x.Name == name)
            .Include(x => x.CompetitionGroups!)
                .ThenInclude(x => x.CompetitionGroupRule)
            .Include(x => x.GymCompetitions)
            .FirstOrDefaultAsync();

        return result;
    }

    public async Task<List<Competition>> GetCompetitionsByGymId(int gymId)
    {
        var result = await dbContext.Competitions
            .Include(x => x.GymCompetitions)
            .Include(x => x.CompetitionGroups)
            .Where(x => x.GymCompetitions!.Any(x => gymId == x.GymId) && x.Archived == false)
            .ToListAsync();

        return result;
    }

    public async Task<List<Competition>> GetCompetitionsByCompetitionGroupIds(List<int> competitionGroupIds)
    {
        var result = await dbContext.Competitions
            .Include(x => x.CompetitionGroups!)
                .Where(x => x.CompetitionGroups!.Any(x => competitionGroupIds.Contains(x.Id)))
                .ToListAsync();

        return result;
    }

    public async Task<Competition?> GetActiveCompetitionById(int id)
    {
        var result = await dbContext.FindAsync<Competition>(id);

        return result;
    }

    public async Task UpdateCompetitionActive(int id, bool active)
    {
        var competition = await dbContext.Competitions.Where(x => x.Id == id).SingleAsync();

        competition.Active = active;

        await dbContext.SaveChangesAsync();
    }

    public async Task ArchiveCompetition(int id)
    {
        var competition = await dbContext.Competitions.Where(x => x.Id == id).SingleAsync();

        competition.Archived = true;

        await dbContext.SaveChangesAsync();
    }
}
