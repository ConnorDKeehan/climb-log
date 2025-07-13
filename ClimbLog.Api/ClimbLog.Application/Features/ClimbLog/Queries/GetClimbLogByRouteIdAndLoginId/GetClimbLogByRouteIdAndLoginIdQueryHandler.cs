using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.ClimbLog.Queries.GetClimbLogByRouteIdAndLoginId;
public class GetClimbLogByRouteIdAndLoginIdQueryHandler(IClimbLogsRepository climbLogsRepository) 
    : IRequestHandler<GetClimbLogByRouteIdAndLoginIdQuery, Domain.Models.Entities.ClimbLog>
{
    public async Task<Domain.Models.Entities.ClimbLog> Handle(GetClimbLogByRouteIdAndLoginIdQuery query, CancellationToken cancellationToken)
    {
        var result = await climbLogsRepository.GetClimbLogByRouteIdAndLoginId(query.RouteId, query.LoginId);

        if (result == null)
        {
            throw new KeyNotFoundException($"No climblog found for user with routeId: {query.RouteId} & loginId: {query.LoginId}");
        }

        return result;
    }
}
