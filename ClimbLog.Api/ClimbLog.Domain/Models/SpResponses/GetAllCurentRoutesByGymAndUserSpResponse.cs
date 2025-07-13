namespace ClimbLog.Domain.Models.SpResponses;

public class GetAllCurentRoutesByGymAndUserSpResponse
{
    public int Id { get; set; }
    public decimal XCord { get; set; }
    public decimal YCord { get; set; }
    public required string GradeName { get; set; }
    public int GradeOrder { get; set; }
    public string? Color { get; set; }
    public string? StandardGradeName { get; set; }
    public int? StandardGradeOrder { get; set; }
    public bool HasAscended { get; set; }
    public int? CompetitionId { get; set; }
    public int? SectorId { get; set; }
    public string? SectorName { get; set; }
}
