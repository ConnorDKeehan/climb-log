using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.ClimbLog.Commands.UnlogClimb;

public class UnlogClimbCommand : IRequest<Unit>
{
    public int LoginId { get; set; }
    public int RouteId { get; set; }
}
