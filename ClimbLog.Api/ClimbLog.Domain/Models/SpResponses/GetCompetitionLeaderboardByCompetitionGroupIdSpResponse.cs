using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.SpResponses;
public class GetCompetitionLeaderboardByCompetitionGroupIdSpResponse
{
    public int CompetitionId {  get; set; }
    public required string CompetitionName {  get; set; }
    public int CompetitionGroupId { get; set; }
    public required string CompetitionGroupName { get; set; }
    public int LoginId { get; set; }
    public required string CompetitorName { get; set; }
    public int Points {  get; set; }
    public int Rank { get; set; }
}
