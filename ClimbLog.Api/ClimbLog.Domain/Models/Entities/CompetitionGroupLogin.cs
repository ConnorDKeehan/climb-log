namespace ClimbLog.Domain.Models.Entities;
public class CompetitionGroupLogin
{
    public int Id { get; set; }
    public int CompetitionGroupId { get; set; }
    public int LoginId { get; set; }
    //Navigational Properties
    public CompetitionGroup? CompetitionGroup { get; set; }
}
