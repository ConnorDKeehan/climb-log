using AutoMapper;
using ClimbLog.Application.Features.Competitions.Queries.GetCompetitionGroupLeaderboard;
using ClimbLog.Application.Features.Competitions.Queries.GetCompetitionGroupsByCompetitionId;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Domain.Models.SpResponses;


namespace ClimbLog.Application.Features.Competitions;
public class CompetitionMappingProfile : Profile
{
    public CompetitionMappingProfile()
    {
        CreateMap<CompetitionGroup, GetCompetitionGroupsByCompetitionIdQueryResponse>();
        CreateMap<GetCompetitionLeaderboardByCompetitionGroupIdSpResponse, GetCompetitionGroupLeaderboardQueryResponse>();
    }
}
