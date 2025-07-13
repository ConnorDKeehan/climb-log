namespace ClimbLog.Api.Responses
{
    public class GetPersonalStatsByGymResponse
    {
        public int TotalPoints { get; set; }
        public int TotalAscents { get; set; }
        public int TotalGymRanking { get; set; }
        public required List<GradeAscendedCount> TotalGradeAscendedCount { get; set; }
        public int LastWeekPoints { get; set; }
        public int LastWeekAscents { get; set; }
        public int LastWeekGymRanking { get; set; }
        public required List<GradeAscendedCount> LastWeekAscendedCount { get; set; }

    }

    public class GradeAscendedCount
    {
        public required string GradeName { get; set; }
        public int NumOfAscents { get; set; }
    }
}
