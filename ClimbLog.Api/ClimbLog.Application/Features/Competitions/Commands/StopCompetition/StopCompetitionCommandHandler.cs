using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Commands.StartCompetition;
public class StopCompetitionCommandHandler(ICompetitionsRepository competitionsRepository) : IRequestHandler<StopCompetitionCommand, Unit>
{
    public async Task<Unit> Handle(StopCompetitionCommand command, CancellationToken cancellationToken = default)
    {
        await competitionsRepository.UpdateCompetitionActive(command.CompetitionId, false);

        return Unit.Value;
    }
}
