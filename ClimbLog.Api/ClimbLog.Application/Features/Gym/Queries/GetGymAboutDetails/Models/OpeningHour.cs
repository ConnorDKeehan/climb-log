namespace ClimbLog.Application.Features.Gym.Queries.GetGymAboutDetails.Models;

public class OpeningHour
{
    public int DayNumber { get; set; }
    public required string WeekDay { get; set; }
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
    public bool Open { get; set; } = true;
}
