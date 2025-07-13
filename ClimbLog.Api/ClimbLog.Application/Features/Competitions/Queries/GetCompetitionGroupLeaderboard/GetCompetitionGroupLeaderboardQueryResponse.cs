using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Queries.GetCompetitionGroupLeaderboard;
public class GetCompetitionGroupLeaderboardQueryResponse
{
    public int LoginId { get; set; }
    public required string CompetitorName {  get; set; }
    public int Points { get; set; }
    public int Rank {  get; set; }
}
