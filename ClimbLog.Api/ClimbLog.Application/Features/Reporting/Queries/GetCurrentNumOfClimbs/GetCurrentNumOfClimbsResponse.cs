using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Reporting.Queries.GetCurrentWeekPoints;
public class GetCurrentNumOfClimbsResponse
{
    public required string Name { get; set; }
    public int Rank { get; set; }
    public int NumOfClimbs { get; set; }
}
