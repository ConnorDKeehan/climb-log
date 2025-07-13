using ClimbLog.Domain.Interfaces;
using MediatR;
using System.Globalization;

namespace ClimbLog.Application.Features.Reporting.Queries.GetCurrentWeekPoints;
public class GetCurrentWeekPointsQueryHandler(IMainDataRepository mainDataRepository) 
    : IRequestHandler<GetCurrentWeekPointsQuery, List<GetCurrentWeekPointsResponse>>
{
    public async Task<List<GetCurrentWeekPointsResponse>> Handle(GetCurrentWeekPointsQuery query, CancellationToken cancellationToken)
    {
        var mainData = await mainDataRepository.GetMainDataByGymNameForCurrentWeek(query.GymName);

        var result = mainData.OrderBy(x => x.PointRank).Select(x =>
            new GetCurrentWeekPointsResponse
            {
                Name = x.LoginName,
                Rank = x.PointRank,
                Points = x.Points,
            }
        ).Take(5).ToList();

        return result;
    }
}
