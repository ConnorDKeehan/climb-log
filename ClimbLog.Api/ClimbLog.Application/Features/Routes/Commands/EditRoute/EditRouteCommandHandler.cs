using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Routes.Commands.EditRoute;
public class EditRouteCommandHandler(
        IRoutesRepository routesRepository
    ) : IRequestHandler<EditRouteCommand, Unit>
{
    public async Task<Unit> Handle(EditRouteCommand command, CancellationToken cancellationToken)
    {
        await routesRepository.UpdateRoute(new Domain.Models.RepoRequests.EditRouteRepoRequest
        {
            RouteId = command.RouteId,
            GradeId = command.GradeId,
            StandardGradeId = command.StandardGradeId,
            CompetitionId = command.CompetitionId,
            PointValue = command.PointValue,
            SectorId = command.SectorId
        });

        return Unit.Value;
    }
}
