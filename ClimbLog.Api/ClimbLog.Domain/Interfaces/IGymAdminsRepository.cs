
using ClimbLog.Domain.Models.Entities;
using MediatR;

namespace ClimbLog.Domain.Interfaces;

public interface IGymAdminsRepository
{
    Task<Unit> AddGymAdmin(GymAdmin gymAdmin);
    Task<bool> IsUserAdmin(List<int> gymId, int loginId);
    Task<Unit> RemoveGymAdmin(int gymId, int loginId);
}