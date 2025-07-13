
namespace ClimbLog.Application.Features.ClimbLog.Commands.UpdateClimbLog;
public class UpdateClimbLogRequest
{
    public int ClimbLogId { get; set; }
    public int? DifficultyForGradeId { get; set; }
    public int? AttemptCount { get; set; }
}
