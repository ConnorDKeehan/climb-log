

namespace ClimbLog.Domain.Models.Entities;
public class Competition
{
    public int Id { get; set; }
    public DateOnly? StartDate { get; set; }
    public DateOnly? EndDate { get; set; }
    public required string Name { get; set; }
    public bool Active { get; set; }
    public bool Archived { get; set; }
    //Navigational Properties
    public List<GymCompetition>? GymCompetitions { get; set; }
    public List<CompetitionGroup>? CompetitionGroups { get; set; }
}
