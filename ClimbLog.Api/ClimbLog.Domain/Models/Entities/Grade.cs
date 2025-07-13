namespace ClimbLog.Domain.Models.Entities
{
    public class Grade
    {
        public int Id { get; set; }
        public int GradeSystemId {  get; set; }
        public required string GradeName { get; set; }
        public int Points { get; set; }
        public string? Color { get; set; }
        public int GradeOrder { get; set; }
    }
}
