using ClimbLog.Domain.Interfaces;
using MediatR;
using System.Globalization;

namespace ClimbLog.Application.Features.Reporting.Queries.GetCurrentWeekPoints;
public class GetCurrentNumOfClimbsQueryHandler(IMainDataRepository mainDataRepository) 
    : IRequestHandler<GetCurrentNumOfClimbsQuery, List<GetCurrentNumOfClimbsResponse>>
{
    public async Task<List<GetCurrentNumOfClimbsResponse>> Handle(GetCurrentNumOfClimbsQuery query, CancellationToken cancellationToken)
    {
        var mainData = await mainDataRepository.GetMainDataByGymNameForCurrentWeek(query.GymName);

        var result = mainData
            .OrderBy(x => x.NumOfClimbsLeftRank)
            .Select(x => new GetCurrentNumOfClimbsResponse
            {
                Name = x.LoginName,
                Rank = x.NumOfClimbsLeftRank,
                NumOfClimbs = x.NumOfClimbsLeft,
            })
            .Take(5)
            .ToList();

        return result;
    }
}
