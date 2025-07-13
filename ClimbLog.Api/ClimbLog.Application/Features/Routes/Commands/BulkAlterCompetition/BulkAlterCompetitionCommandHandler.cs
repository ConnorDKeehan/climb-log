using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Routes.Commands.BulkAlterCompetition;

public class BulkAlterCompetitionCommandHandler(IRoutesRepository routesRepository) : IRequestHandler<BulkAlterCompetitionCommand, Unit>
{
    public async Task<Unit> Handle(BulkAlterCompetitionCommand request, CancellationToken cancellationToken)
    {
        await routesRepository.BulkAlterCompetition(request.CompetitionId, request.RouteIds);

        return Unit.Value;
    }
}
