namespace ClimbLog.Domain.Models.Views;
public class vwMainData
{
    public int LoginId { get; set; }
    public required string LoginName { get; set; }
    public int GymId { get; set; }
    public required string GymName { get; set; }
    public int Year { get; set; }
    public int Week { get; set; }
    public int Points { get; set; }
    public int Ascents { get; set; }
    public int NumOfClimbsLeft { get; set; }
    public int PointRank { get; set; }
    public int AscentRank { get; set; }
    public int NumOfClimbsLeftRank { get; set; }
}
