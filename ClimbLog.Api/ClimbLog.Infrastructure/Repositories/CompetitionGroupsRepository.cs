using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Infrastructure.Repositories;
public class CompetitionGroupsRepository(ClimbLogContext dbContext) : ICompetitionGroupsRepository
{
    public async Task<CompetitionGroup?> GetCompetitionGroupsByCompIdAndLoginId(int competitionId, int loginId)
    {
        var result = await dbContext.CompetitionGroups
            .Include(x => x.CompetitionGroupLogins)
            .Where(x => x.CompetitionGroupLogins!.Any(x => x.LoginId == loginId) && x.CompetitionId == competitionId)
            .SingleOrDefaultAsync();

        return result;
    }

    public async Task<List<CompetitionGroup>> GetCompetitionGroupsByCompetitionId(int competitionId)
    {
        var result = await dbContext.CompetitionGroups.Where(x => x.CompetitionId == competitionId).ToListAsync();

        return result;
    }
}
