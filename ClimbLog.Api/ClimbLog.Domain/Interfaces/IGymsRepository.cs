using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces;

public interface IGymsRepository
{
    Task AddGym(Gym gym);
    Task<List<Gym>> GetAllGyms();
    Task<Gym> GetGymAboutDetailsByName(string name);
    Task<Gym> GetGymByName(string name);
    Task<Gym> GetGymByRouteId(int routeId);
    Task<List<string>> GetGymNamesByGymAdmin(int loginId);
    Task<List<Gym>> GetGymsByNames(List<string> names);
    Task<bool> IsUserACompetitionAdmin(int competitionId, int loginId);
    Task UpdateGymAddress(int id, string address);
}