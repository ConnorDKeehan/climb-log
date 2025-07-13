using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Grades.Queries.GetGymGradeNamesByGymName;

public class GetGymGradeNamesByGymNameQueryResponse
{
    public List<string> Grades { get; set; }
    public List<string> StandardGrades { get; set; }
}
