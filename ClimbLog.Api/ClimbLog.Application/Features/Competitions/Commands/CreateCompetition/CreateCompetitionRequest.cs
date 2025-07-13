using ClimbLog.Application.Features.Competitions.Commands.CreateCompetition.Models;

namespace ClimbLog.Application.Features.Competitions.Commands.CreateCompetition;
public class CreateCompetitionRequest
{
    public required List<string> GymNames { get; set; }
    public required string CompetitionName { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public required List<CompetitionGroupRequest> CompetitionGroupsRequest { get; set; }
}
