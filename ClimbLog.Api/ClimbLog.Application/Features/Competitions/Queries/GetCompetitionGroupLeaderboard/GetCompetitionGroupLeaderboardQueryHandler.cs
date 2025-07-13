using AutoMapper;
using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Competitions.Queries.GetCompetitionGroupLeaderboard;
public class GetCompetitionGroupLeaderboardQueryHandler(IStoredProceduresRepository storedProceduresRepository, IMapper mapper) 
    : IRequestHandler<GetCompetitionGroupLeaderboardQuery, List<GetCompetitionGroupLeaderboardQueryResponse>>
{
    public async Task<List<GetCompetitionGroupLeaderboardQueryResponse>> Handle(
        GetCompetitionGroupLeaderboardQuery query, 
        CancellationToken cancellationToken = default
        ) 
    {
        var leaderBoardSpResponse = await storedProceduresRepository.GetCompetitionLeaderboardByCompetitionGroupId(query.CompetitionGroupId);

        var result = mapper.Map<List<GetCompetitionGroupLeaderboardQueryResponse>>(leaderBoardSpResponse);

        return result;
    }
}
