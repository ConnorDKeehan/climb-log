using ClimbLog.Domain.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Routes.Queries.GetInfoForUpsertingRoute;

public class GetInfoForUpsertingRouteQueryResponse
{
    public required List<Grade> Grades { get; set; }
    public required List<Grade> StandardGrades { get; set; }
    public required List<Sector> Sectors { get; set; }
    public required List<Competition> Competitions { get; set; }
    public Grade? CurrentGrade { get; set; }
    public Grade? CurrentStandardGrade { get; set; }
    public Sector? CurrentSector { get; set; }
    public Competition? CurrentCompetition { get; set; }
    public int? CurrentPointValue { get; set; }
}
