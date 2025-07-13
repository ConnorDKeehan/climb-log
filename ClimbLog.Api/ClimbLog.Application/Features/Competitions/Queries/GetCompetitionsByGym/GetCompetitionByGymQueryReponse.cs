using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Queries.GetCompetitionsByGym;
public class GetCompetitionByGymQueryReponse
{
    public int CompetitionId { get; set; }
    public int? CompetitionGroupId { get; set; }
    public required string CompetitionName { get; set; }
    public bool IsUserEntered { get; set; }
    public bool Active { get; set; }
    public int? SingleGroupId { get; set; }
    public DateOnly? StartDate { get; set; }
    public DateOnly? EndDate { get; set; }
}
