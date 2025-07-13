using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.ClimbLog.Commands.UnlogClimb;
public class UnlogClimbCommandHandler(IClimbLogsRepository climbLogsRepository) : IRequestHandler<UnlogClimbCommand, Unit>
{
    public async Task<Unit> Handle(UnlogClimbCommand command, CancellationToken cancellationToken)
    {
        await climbLogsRepository.DeleteClimbLog(command.RouteId, command.LoginId);

        return Unit.Value;
    }
}
