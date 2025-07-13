using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Queries.GetCompetitionGroupLeaderboard;
public class GetCompetitionGroupLeaderboardQuery : IRequest<List<GetCompetitionGroupLeaderboardQueryResponse>>
{
    public int CompetitionGroupId { get; set; }
}
