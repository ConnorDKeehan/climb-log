using ClimbLog.Application.Features.Grades.Queries.GetGymGradesByGymName;
using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;

namespace ClimbLog.Application.Features.Routes.Commands.OldAddRoute;

public class OldAddRouteCommandHandler(IRoutesRepository routesRepository, IGymsRepository gymsRepository, IMediator mediator)
    : IRequestHandler<OldAddRouteCommand, Unit>
{
    public async Task<Unit> Handle(OldAddRouteCommand command, CancellationToken cancellationToken = default)
    {
        var gym = await gymsRepository.GetGymByName(command.GymName);
        var gymGrades = await mediator.Send(new GetGymGradesByGymNameQuery { GymName = command.GymName});

        var standardGrade = gymGrades.StandardGrades.Where(x => x.GradeName == command.StandardGrade).FirstOrDefault();
        var grade = gymGrades.Grades.Where(x => x.GradeName == command.Grade).First();


        var newRoute = new Route
        {
            GymId = gym.Id,
            XCord = command.XCord,
            YCord = command.YCord,
            GradeId = grade!.Id,
            StandardGradeId = standardGrade?.Id,
            Points = command.PointValue ?? standardGrade?.Points ?? grade.Points,
            CompetitionId = command.CompetitionId,
            DateAddedUTC = DateTime.UtcNow,
            SectorId = command.SectorId
        };

        var route = await routesRepository.AddRoute(newRoute);

        return Unit.Value;
    }
}
