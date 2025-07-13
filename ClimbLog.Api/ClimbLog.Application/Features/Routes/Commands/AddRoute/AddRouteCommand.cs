using MediatR;

namespace ClimbLog.Application.Features.Routes.Commands.AddRoute;

public class AddRouteCommand : IRequest<Unit>
{
    public required string GymName { get; set; }
    public decimal XCord { get; set; }
    public decimal YCord { get; set; }
    public int GradeId { get; set; }
    public int PointValue { get; set; }
    public int? StandardGradeId { get; set; }
    public int? CompetitionId { get; set; }
    public int? SectorId { get; set; }
}
