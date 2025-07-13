using ClimbLog.Application.Features.Gym.Queries.GetGymAboutDetails.Models;
using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Application.Features.Gym.Queries.GetGymAboutDetails;

public class GetGymAboutDetailsQueryResponse
{
    public required string GymName { get; set; }
    public string? Address { get; set; }
    public bool? CurrentlyOpen { get; set; }
    public TimeOnly? TodayStartTime { get; set; }
    public TimeOnly? TodayEndTime { get; set; }
    public required List<OpeningHour> OpeningHours { get; set; }
    public required List<Facility> Facilities { get; set; }
}