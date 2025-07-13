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
public class CompetitionGroupLoginsRepository(ClimbLogContext dbContext) : ICompetitionGroupLoginsRepository
{
    public async Task<List<int>> GetCompetitionGroupIdsFromLoginId(int loginId)
    {
        var result = await dbContext.CompetitionGroupLogins.Where(x => x.LoginId == loginId).Select(x => x.CompetitionGroupId).ToListAsync();

        return result;
    }

    public async Task Add(int loginId, int competitionGroupId)
    {
        await dbContext.CompetitionGroupLogins.AddAsync(new CompetitionGroupLogin { LoginId = loginId, CompetitionGroupId = competitionGroupId});

        await dbContext.SaveChangesAsync();
    }

    public async Task DeleteByLoginIdAndCompetitionId(int loginId, int competitionId)
    {
        await dbContext.CompetitionGroupLogins
            .Include(x => x.CompetitionGroup)
            .Where(x => x.LoginId == loginId && x.CompetitionGroup!.CompetitionId == competitionId).ExecuteDeleteAsync();
    }
}
