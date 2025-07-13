using MediatR;

namespace ClimbLog.Application.Features.Routes.Commands.ArchiveRoute;

public class ArchiveRouteCommand : IRequest<Unit>
{
    public int Id { get; set; }
}
