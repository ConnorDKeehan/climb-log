using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces;
public interface ISectorsRepository
{
    Task<List<Sector>> GetSectorsByGymId(int gymId);
}