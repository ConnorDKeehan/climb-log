using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Commands.StartCompetition;
public class ArchiveCompetitionCommandHandler(ICompetitionsRepository competitionsRepository) : IRequestHandler<ArchiveCompetitionCommand, Unit>
{
    public async Task<Unit> Handle(ArchiveCompetitionCommand command, CancellationToken cancellationToken = default)
    {
        await competitionsRepository.ArchiveCompetition(command.CompetitionId);

        return Unit.Value;
    }
}
