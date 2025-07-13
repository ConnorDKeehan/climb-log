using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using ClimbLog.Domain.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace ClimbLog.Infrastructure.Repositories;

public class GymsRepository(ClimbLogContext dbContext) : IGymsRepository
{
    public async Task AddGym(Gym gym)
    {
        await dbContext.Gyms.AddAsync(gym);
        await dbContext.SaveChangesAsync();
    }
    public async Task<Gym> GetGymByName(string name)
    {
        var result = await dbContext.Gyms.Where(x => x.Name == name).SingleOrDefaultAsync();

        if (result == null)
        {
            throw new ArgumentException($"Gym name {name} doesn't have a corresponding gym");
        }

        return result;
    }

    public async Task<List<Gym>> GetGymsByNames(List<string> names)
    {
        var result = await dbContext.Gyms.Where(x => names.Contains(x.Name)).ToListAsync();

        return result;
    }

    public async Task<Gym> GetGymAboutDetailsByName(string name)
    {
        var result = await dbContext.Gyms
            .Where(x => x.Name == name)
            .Include(x => x.GymFacilities!)
                .ThenInclude(x => x.Facility)
            .Include(x => x.GymDefaultOpeningHours)
            .SingleOrDefaultAsync();

        if (result == null)
        {
            throw new ArgumentException($"Gym name {name} doesn't have a corresponding gym");
        }

        return result;
    }

    public async Task<List<string>> GetGymNamesByGymAdmin(int loginId)
    {
        var result = await dbContext.Gyms
            .Include(g => g.GymAdmins)
            .Where(g => g.GymAdmins!.Any(ga => ga.LoginId == loginId))
            .Select(x => x.Name)
            .ToListAsync();

        return result;
    }

    public async Task<List<Gym>> GetAllGyms()
    {
        return await dbContext.Gyms.ToListAsync();
    }

    public async Task UpdateGymAddress(int id, string address)
    {
        var gym = await dbContext.Gyms.Where(x => x.Id == id).SingleAsync();

        gym.Address = address;
        
        await dbContext.SaveChangesAsync();
    }

    public async Task<bool> IsUserACompetitionAdmin(int competitionId, int loginId)
    {
        var result = await dbContext.Gyms
            .Include(x => x.GymAdmins)
            .Include(x => x.GymCompetitions)
            .Where(x => x.GymCompetitions!.Any(x => x.CompetitionId == competitionId) && x.GymAdmins!.Any(x => x.LoginId == loginId))
            .AnyAsync();

        return result;
    }

    public async Task<Gym> GetGymByRouteId(int routeId)
    {
        var result = await dbContext.Gyms
            .Include(x => x.Routes)
            .Where(x => x.Routes!.Any(x => x.Id == routeId))
            .SingleAsync();

        return result;
    }
}
