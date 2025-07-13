using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Commands.LeaveCompetition;
public class LeaveCompetitionCommandHandler(
    ICompetitionGroupLoginsRepository competitionGroupLoginsRepository
    ) : IRequestHandler<LeaveCompetitionCommand, Unit>
{
    public async Task<Unit> Handle(LeaveCompetitionCommand command, CancellationToken cancellationToken = default)
    {
        await competitionGroupLoginsRepository.DeleteByLoginIdAndCompetitionId(command.LoginId, command.CompetitionId);

        return Unit.Value;
    }
}
