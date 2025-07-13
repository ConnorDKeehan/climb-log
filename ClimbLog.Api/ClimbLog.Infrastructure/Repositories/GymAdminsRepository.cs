using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using ClimbLog.Domain.Interfaces;
using MediatR;
using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Infrastructure.Repositories;

public class GymAdminsRepository(ClimbLogContext dbContext) : IGymAdminsRepository
{
    public async Task<bool> IsUserAdmin(List<int> gymIds, int loginId)
    {
        var result = await dbContext.GymAdmins.Where(x => gymIds.Contains(x.GymId) && x.LoginId == loginId).CountAsync();

        var isUserAdminAtAllGyms = result >= gymIds.Count();

        return isUserAdminAtAllGyms;
    }

    public async Task<Unit> AddGymAdmin(GymAdmin gymAdmin)
    {
        await dbContext.GymAdmins.AddAsync(gymAdmin);
        await dbContext.SaveChangesAsync();

        return Unit.Value;
    }

    public async Task<Unit> RemoveGymAdmin(int gymId, int loginId)
    {
        var rowsAffected = await dbContext.GymAdmins
            .Where(x => x.GymId == gymId && x.LoginId == loginId)
            .ExecuteDeleteAsync();

        return Unit.Value;
    }
}
