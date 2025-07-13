using AutoMapper;
using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Competitions.Queries.GetCompetitionGroupsByCompetitionId;
public class GetCompetitionGroupsByCompetitionIdQueryHandler(ICompetitionGroupsRepository competitionGroupsRepository, IMapper mapper) 
    : IRequestHandler<GetCompetitionGroupsByCompetitionIdQuery, List<GetCompetitionGroupsByCompetitionIdQueryResponse>>
{
    public async Task<List<GetCompetitionGroupsByCompetitionIdQueryResponse>> Handle(GetCompetitionGroupsByCompetitionIdQuery query, CancellationToken cancellationToken)
    {
        var competitionGroups = await competitionGroupsRepository.GetCompetitionGroupsByCompetitionId(query.CompetitionId);

        var result = mapper.Map<List<GetCompetitionGroupsByCompetitionIdQueryResponse>>(competitionGroups);

        return result;
    }
}
