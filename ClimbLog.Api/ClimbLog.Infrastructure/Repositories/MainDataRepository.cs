using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.SpResponses;
using ClimbLog.Domain.Models.Views;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Globalization;

namespace ClimbLog.Infrastructure.Repositories;
public class MainDataRepository(ClimbLogContext dbContext) : IMainDataRepository
{
    public async Task<List<vwMainData>> GetMainDataByGymNameAndLoginId(string gymName, int loginId)
    {
        var result = await dbContext.vwMainData.Where(x => x.GymName == gymName && x.LoginId == loginId).ToListAsync();

        return result;
    }

    public async Task<List<vwMainData>> GetMainDataByGymNameForCurrentWeek(string gymName)
    {
        var currentDateTime = DateTime.Now;

        int weekNumber = CultureInfo.CurrentCulture.Calendar.GetWeekOfYear(
            currentDateTime,
            CalendarWeekRule.FirstDay,
            DayOfWeek.Monday
        );
        var result = await dbContext.vwMainData.Where(x => x.GymName == gymName && x.Week == weekNumber && x.Year == currentDateTime.Year).ToListAsync();

        return result;
    }
}
