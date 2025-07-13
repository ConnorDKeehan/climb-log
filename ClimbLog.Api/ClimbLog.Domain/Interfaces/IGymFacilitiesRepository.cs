using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces;

public interface IGymFacilitiesRepository
{
    Task AddGymFacility(int gymId, int facilityId);
    Task DeleteGymFacility(int gymId, int facilityId);
    Task<List<int>> GetGymFacilityIdsByGymId(int gymId);
    Task ReplaceGymFacilities(int gymId, List<int> newFacilityIds);
}
