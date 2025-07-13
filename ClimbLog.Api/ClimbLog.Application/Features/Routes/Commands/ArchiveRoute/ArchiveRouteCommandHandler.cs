using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Routes.Commands.ArchiveRoute;

public class ArchiveRouteCommandHandler(IRoutesRepository routesRepository)
    : IRequestHandler<ArchiveRouteCommand, Unit>
{
    public async Task<Unit> Handle(ArchiveRouteCommand command, CancellationToken cancellationToken = default)
    {
        await routesRepository.ArchiveRoute(command.Id);

        return Unit.Value;
    }
}
