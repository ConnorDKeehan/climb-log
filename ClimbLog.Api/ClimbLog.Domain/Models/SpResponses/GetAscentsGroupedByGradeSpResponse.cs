namespace ClimbLog.Domain.Models.SpResponses
{
    public class GetAscentsGroupedByGradeSpResponse
    {
        public required string GradeName { get; set; }
        public int NumOfAscents { get; set; }
    }
}
