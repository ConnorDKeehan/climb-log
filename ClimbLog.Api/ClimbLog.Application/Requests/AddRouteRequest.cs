namespace ClimbLog.Api.Requests;
public class AddRouteRequest
{
    public decimal XCord { get; set; }
    public decimal YCord { get; set; }
    public required string Grade { get; set; }
    public string? StandardGrade { get; set; }
    public int? CompetitionId { get; set; }
    public int? PointValue { get; set; }
    public int? SectorId { get; set; }
}
