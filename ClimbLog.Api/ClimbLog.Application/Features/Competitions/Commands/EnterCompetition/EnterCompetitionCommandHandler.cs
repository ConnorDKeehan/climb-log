using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Commands.EnterCompetition;
public class EnterCompetitionCommandHandler(ICompetitionGroupLoginsRepository competitionGroupLoginsRepository) 
    : IRequestHandler<EnterCompetitionCommand, Unit>
{
    public async Task<Unit> Handle(EnterCompetitionCommand command, CancellationToken cancellationToken = default)
    {
        await competitionGroupLoginsRepository.Add(command.LoginId, command.CompetitionGroupId);

        return Unit.Value;
    }
}
