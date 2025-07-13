using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Domain.Interfaces;

public interface IGymDefaultOpeningHoursRepository
{
    Task<GymDefaultOpeningHour?> GetGymDefaultOpeningHourByGymIdAndWeekDay(int gymId, string weekDay);
    Task UpsertGymDefaultOpeningHour(int gymId, string weekDay, TimeOnly startTime, TimeOnly endTime);
}