using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Routes.Commands.ArchiveRoutes;

public class ArchiveRoutesCommandHandler(IRoutesRepository routesRepository)
    : IRequestHandler<ArchiveRoutesCommand, Unit>
{
    public async Task<Unit> Handle(ArchiveRoutesCommand command, CancellationToken cancellationToken = default)
    {
        await routesRepository.ArchiveRoutes(command.Ids);

        return Unit.Value;
    }
}
