namespace ClimbLog.Domain.Models.Entities;

public class Gym
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public int GradeSystemId { get; set; }
    public int ViewBoxXSize { get; set; }
    public int ViewBoxYSize { get; set; }
    public int? StandardGradeSystemId { get; set; }
    public string? Address { get; set; }
    public required string TimeZoneIdentifier { get; set; }
    public required string FloorPlanSvgUrl { get; set; }
    public bool EnableSectors {  get; set; }
    //Navigational Properties
    public List<GymFacility>? GymFacilities { get; set; }
    public List<GymDefaultOpeningHour>? GymDefaultOpeningHours { get; set; }
    public List<GymAdmin>? GymAdmins { get; set; }
    public List<GymCompetition>? GymCompetitions { get; set; }
    public List<Route>? Routes { get; set; }
}
