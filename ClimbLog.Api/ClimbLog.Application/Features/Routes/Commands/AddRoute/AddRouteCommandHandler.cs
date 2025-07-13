using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;

namespace ClimbLog.Application.Features.Routes.Commands.AddRoute;

public class AddRouteCommandHandler(IRoutesRepository routesRepository, IGymsRepository gymsRepository) : IRequestHandler<AddRouteCommand, Unit>
{
    public async Task<Unit> Handle(AddRouteCommand command, CancellationToken cancellationToken)
    {
        var gym = await gymsRepository.GetGymByName(command.GymName);

        var route = new Route
        {
            GymId = gym.Id,
            XCord = command.XCord,
            YCord = command.YCord,
            GradeId = command.GradeId,
            StandardGradeId = command.StandardGradeId,
            Archived = false,
            CompetitionId = command.CompetitionId,
            Points = command.PointValue,
            DateAddedUTC = DateTime.UtcNow,
            SectorId = command.SectorId
        };

        await routesRepository.AddRoute(route);

        return Unit.Value;
    }
}
