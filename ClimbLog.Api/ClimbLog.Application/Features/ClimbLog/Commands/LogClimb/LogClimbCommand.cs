using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.ClimbLog.Commands.LogClimb;

public class LogClimbCommand : IRequest<Unit>
{
    public int RouteId { get; set; }
    public int LoginId { get; set; }
    //Must be optional as these are new params and won't be avaliable for users on old versions.
    public int? AttemptCount { get; set; }
    public string? Notes { get; set; }
    public int? DifficultyForGradeId { get; set; }
}
