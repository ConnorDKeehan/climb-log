
namespace ClimbLog.Application.Features.ClimbLog.Commands.LogClimb;
public class LogClimbRequest
{
    public int RouteId { get; set; }
    public int? DifficultyForGradeId { get; set; }
    public int? AttemptCount { get; set; }
    public string? Notes { get; set; }
}
