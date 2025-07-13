using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Routes.Commands.MoveRoute;
public class MoveRouteCommandHandler(IRoutesRepository routesRepository) : IRequestHandler<MoveRouteCommand, Unit>
{
    public async Task<Unit> Handle(MoveRouteCommand command, CancellationToken cancellationToken)
    {
        await routesRepository.MoveRoute(command.RouteId, command.XCord, command.YCord);

        return Unit.Value;
    }
}
