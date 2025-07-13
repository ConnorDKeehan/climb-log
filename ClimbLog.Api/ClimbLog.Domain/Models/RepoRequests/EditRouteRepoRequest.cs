using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.RepoRequests;
public class EditRouteRepoRequest
{
    public int RouteId { get; set; }
    public int GradeId { get; set; }
    public int? StandardGradeId { get; set; }
    public int? CompetitionId { get; set; }
    public int? PointValue { get; set; }
    public int? SectorId { get; set; }
}
