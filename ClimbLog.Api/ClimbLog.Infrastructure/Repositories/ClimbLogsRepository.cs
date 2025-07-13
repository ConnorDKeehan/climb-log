using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClimbLog.Domain.Interfaces;
using MediatR;
using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Infrastructure.Repositories;

public class ClimbLogsRepository(ClimbLogContext dbContext) : IClimbLogsRepository
{
    public async Task<List<Domain.Models.Entities.ClimbLog>> GetAllClimbLogsByLoginId(int loginId)
    {
        return await dbContext.ClimbLogs.Where(x => x.LoginId == loginId).ToListAsync();
    }
    public async Task LogClimb(Domain.Models.Entities.ClimbLog climbLog)
    {
        await dbContext.ClimbLogs.AddAsync(climbLog);
        await dbContext.SaveChangesAsync();
    }
    
    public async Task<Domain.Models.Entities.ClimbLog?> GetClimbLogByRouteIdAndLoginId(int routeId, int loginId)
    {
        var result = await dbContext.ClimbLogs.Where(x => x.RouteId == routeId && x.LoginId == loginId).SingleOrDefaultAsync();

        return result;
    }

    public async Task<Domain.Models.Entities.ClimbLog> GetClimbLogById(int id)
    {
        var result = await dbContext.ClimbLogs.FindAsync(id);

        if (result == null)
        {
            throw new KeyNotFoundException("Climb log not found.");
        }

        return result;
    }

    public async Task UpdateClimbLog(Domain.Models.Entities.ClimbLog climbLog)
    {
        var existingClimbLog = await dbContext.ClimbLogs.FindAsync(climbLog.Id);

        if (existingClimbLog == null)
        {
            throw new KeyNotFoundException("Climb log not found.");
        }

        // Update fields explicitly to avoid overwriting unintended changes
        dbContext.Entry(existingClimbLog).CurrentValues.SetValues(climbLog);

        await dbContext.SaveChangesAsync();
    }

    public async Task DeleteClimbLog(int routeId, int loginId)
    {
        await dbContext.ClimbLogs.Where(x => x.RouteId == routeId && x.LoginId == loginId).ExecuteDeleteAsync();
    }

    public async Task<List<Domain.Models.Entities.ClimbLog>> GetDetailedClimbLogsByRouteId(int routeId)
    {
        var result = await dbContext.ClimbLogs
            .Include(x => x.DifficultyForGrade)
            .Include(x => x.Login)
            .Where(x => x.RouteId == routeId)
            .ToListAsync();

        return result;
    }
}
