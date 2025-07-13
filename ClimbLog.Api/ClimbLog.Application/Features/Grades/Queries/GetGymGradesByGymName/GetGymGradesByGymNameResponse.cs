using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Application.Features.Grades.Queries.GetGymGradesByGymName;

public class GetGymGradesByGymNameResponse
{
    public required List<Grade> Grades { get; set; }
    public required List<Grade> StandardGrades { get; set; }
}
