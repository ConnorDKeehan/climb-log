namespace ClimbLog.Domain.Models.SpResponses
{
    public class GetPointsAndAscentsSpResponse
    {
        public int TotalPoints { get; set; }
        public int TotalAscents { get; set; }
        public int TotalGymRanking { get; set; }
        public int LastWeekPoints { get; set; }
        public int LastWeekAscents { get; set; }
        public int LastWeekGymRanking { get; set; }
    }
}
