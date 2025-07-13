namespace ClimbLog.Application.Features.Competitions.Commands.CreateCompetition.Models;
public class CompetitionGroupRequest
{
    public required string Name { get; set; }
    public int? NumberOfClimbsIncluded { get; set; }
}
