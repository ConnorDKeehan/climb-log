using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.SpResponses;
public class GetAscentsGroupedByGradeByDateSpResponse
{
    public DateOnly Date {  get; set; }
    public required string GradeName { get; set; }
    public int Week { get; set; }
    public int Month { get; set; }
    public int Year { get; set; }
    public int NumOfAscents { get; set; }
}
