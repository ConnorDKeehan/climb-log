using MediatR;

namespace ClimbLog.Application.Features.ClimbLog.Commands.UpdateClimbLog;
public class UpdateClimbLogCommand : IRequest<Unit>
{
    public int ClimbLogId { get; set; }
    public int LoginId { get; set; }
    public int? DifficultyForGradeId { get; set; }
    public int? AttemptCount { get; set; }
}
