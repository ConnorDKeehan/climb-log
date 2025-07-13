using ClimbLog.Infrastructure.Contexts;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Domain.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace ClimbLog.Infrastructure.Repositories;

public class GymFacilitiesRepository(ClimbLogContext dbContext) : IGymFacilitiesRepository
{
    public async Task AddGymFacility(int gymId, int facilityId)
    {
        await dbContext.GymFacilities.AddAsync(new GymFacility { GymId = gymId, FacilityId = facilityId });

        await dbContext.SaveChangesAsync();
    }

    public async Task DeleteGymFacility(int gymId, int facilityId)
    {
        await dbContext.GymFacilities.Where(x => x.GymId == gymId && x.FacilityId == facilityId).ExecuteDeleteAsync();
    }

    public async Task<List<int>> GetGymFacilityIdsByGymId(int gymId)
    {
        var result = await dbContext.GymFacilities.Where(x => x.GymId == gymId).Select(x => x.FacilityId).ToListAsync();

        return result;
    }

    public async Task ReplaceGymFacilities(int gymId, List<int> newFacilityIds)
    {
        // Start a transaction to ensure atomicity
        using var transaction = await dbContext.Database.BeginTransactionAsync();

        try
        {
            // Step 1: Delete all current facilities for the gym
            await dbContext.GymFacilities
                .Where(x => x.GymId == gymId)
                .ExecuteDeleteAsync();

            // Step 2: Add new facilities
            var newFacilities = newFacilityIds.Select(facilityId => new GymFacility
            {
                GymId = gymId,
                FacilityId = facilityId
            });

            await dbContext.GymFacilities.AddRangeAsync(newFacilities);

            // Save changes
            await dbContext.SaveChangesAsync();

            // Commit transaction
            await transaction.CommitAsync();
        }
        catch
        {
            // Rollback transaction in case of error
            await transaction.RollbackAsync();
            throw;
        }
    }
}
