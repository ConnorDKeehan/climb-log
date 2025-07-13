using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces;

public interface IFacilitiesRepository
{
    Task<List<Facility>> GetAllFacilities();
    Task<Facility> GetFacilityByName(string name);
}