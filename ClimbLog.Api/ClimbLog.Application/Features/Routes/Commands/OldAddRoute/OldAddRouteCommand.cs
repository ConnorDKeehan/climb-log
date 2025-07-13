using Amazon.Runtime.Internal;
using MediatR;

namespace ClimbLog.Application.Features.Routes.Commands.OldAddRoute;

public class OldAddRouteCommand : IRequest<Unit>
{
    public required string GymName { get; set; }
    public decimal XCord { get; set; }
    public decimal YCord { get; set; }
    public required string Grade { get; set; }
    public string? StandardGrade { get; set; }
    public int? CompetitionId { get; set; }
    public int? PointValue { get; set; }
    public int? SectorId { get; set; }
}
