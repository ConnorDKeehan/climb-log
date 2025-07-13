using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;

namespace ClimbLog.Infrastructure.Repositories;

public class GymDefaultOpeningHoursRepository(ClimbLogContext dbContext) : IGymDefaultOpeningHoursRepository
{
    public async Task UpsertGymDefaultOpeningHour(int gymId, string weekDay, TimeOnly startTime, TimeOnly endTime)
    {
        bool isValidWeekDay = Enum.TryParse<DayOfWeek>(weekDay, true, out _);

        if (!isValidWeekDay)
            throw new ArgumentException("{weekDay} is not a valid week day", weekDay);

        var existingRecord = await GetGymDefaultOpeningHourByGymIdAndWeekDay(gymId, weekDay);

        if (existingRecord != null)
        {
            existingRecord.StartTime = startTime;
            existingRecord.EndTime = endTime;
        }
        else
        {
            var newRecord = new GymDefaultOpeningHour { GymId = gymId, WeekDay = weekDay, StartTime = startTime, EndTime = endTime };
            await dbContext.GymDefaultOpeningHours.AddAsync(newRecord);
        }

        await dbContext.SaveChangesAsync();
    }

    public async Task<GymDefaultOpeningHour?> GetGymDefaultOpeningHourByGymIdAndWeekDay(int gymId, string weekDay)
    {
        var existingRecord = await dbContext.GymDefaultOpeningHours.Where(x => x.GymId == gymId && x.WeekDay == weekDay).SingleOrDefaultAsync();

        return existingRecord;
    }
}
