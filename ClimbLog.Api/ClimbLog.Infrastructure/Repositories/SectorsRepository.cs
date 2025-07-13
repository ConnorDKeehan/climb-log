using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;

namespace ClimbLog.Infrastructure.Repositories;
public class SectorsRepository(ClimbLogContext dbContext) : ISectorsRepository
{
    public async Task<List<Sector>> GetSectorsByGymId(int gymId)
    {
        var result = await dbContext.Sectors.Where(x => x.GymId == gymId).ToListAsync();

        return result;
    }
}
