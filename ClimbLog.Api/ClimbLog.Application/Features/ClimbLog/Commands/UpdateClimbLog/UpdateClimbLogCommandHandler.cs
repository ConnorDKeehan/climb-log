using Amazon.Runtime.Internal;
using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.ClimbLog.Commands.UpdateClimbLog;
public class UpdateClimbLogCommandHandler(IClimbLogsRepository climbLogsRepository) : IRequestHandler<UpdateClimbLogCommand, Unit>
{
    public async Task<Unit> Handle(UpdateClimbLogCommand command, CancellationToken cancellationToken)
    {
        var climbLog = await climbLogsRepository.GetClimbLogById(command.ClimbLogId);

        if (climbLog.LoginId != command.LoginId) {
            throw new UnauthorizedAccessException($"ClimbLog with Id: {command.ClimbLogId} doesn't belong to loginId: {command.LoginId}");
        }

        climbLog.DifficultyForGradeId = command.DifficultyForGradeId;
        climbLog.AttemptCount = command.AttemptCount;

        await climbLogsRepository.UpdateClimbLog(climbLog);

        return Unit.Value;
    }
}
