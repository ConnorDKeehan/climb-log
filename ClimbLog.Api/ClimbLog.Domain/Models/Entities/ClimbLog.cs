namespace ClimbLog.Domain.Models.Entities;

public class ClimbLog
{
    public int Id { get; set; }
    public DateOnly Date { get; set; }
    public int LoginId { get; set; }
    public int RouteId { get; set; }
    public int? CompetitionGroupId { get; set; }
    public DateTime DateAdded { get; set; }
    public DateTime DateAddedUTC { get; set; }
    public int? DifficultyForGradeId { get; set; }
    public int? AttemptCount { get; set; }
    public string? Notes { get; set; }
    //Navigational Properties
    public Route? Route { get; set; }
    public Login? Login { get; set; }
    public DifficultyForGrade? DifficultyForGrade { get; set; }
}
