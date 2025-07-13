using System.ComponentModel.DataAnnotations.Schema;

namespace ClimbLog.Domain.Models.Entities;

public class Route
{
    public int Id { get; set; }
    public int GymId { get; set; }
    [Column(TypeName = "decimal(6,6)")]
    public decimal XCord {  get; set; }
    [Column(TypeName = "decimal(6,6)")]
    public decimal YCord { get; set; }
    public int GradeId { get; set; }
    public int? StandardGradeId { get; set; }
    public bool Archived { get; set; }
    public int? CompetitionId { get; set; }
    public int? Points { get; set; }
    public required DateTime DateAddedUTC { get; set; }
    public DateTime? DateArchivedUTC { get; set; }
    public int? SectorId { get; set; }
    //Navigational Properties
    public Gym? Gym { get; set; }
    public Competition? Competition { get; set; }
    public Sector? Sector { get; set; }
    public Grade? Grade { get; set; }
    public Grade? StandardGrade { get; set; }
}
