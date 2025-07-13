using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;

namespace ClimbLog.Infrastructure.Repositories;

public class FacilitiesRepository(ClimbLogContext dbContext) : IFacilitiesRepository
{
    public async Task<Facility> GetFacilityByName(string name)
    {
        var result = await dbContext.Facilities.Where(x => x.Name == name).SingleOrDefaultAsync();

        if (result == null)
            throw new ArgumentException("facility name: {name}, doesn't exist", name);

        return result;
    }

    public async Task<List<Facility>> GetAllFacilities()
    {
        var result = await dbContext.Facilities.ToListAsync();

        return result;
    }
}
