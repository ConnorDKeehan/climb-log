using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Commands.StartCompetition;
public class StartCompetitionCommandHandler(ICompetitionsRepository competitionsRepository) : IRequestHandler<StartCompetitionCommand, Unit>
{
    public async Task<Unit> Handle(StartCompetitionCommand command, CancellationToken cancellationToken = default)
    {
        await competitionsRepository.UpdateCompetitionActive(command.CompetitionId, true);

        return Unit.Value;
    }
}
