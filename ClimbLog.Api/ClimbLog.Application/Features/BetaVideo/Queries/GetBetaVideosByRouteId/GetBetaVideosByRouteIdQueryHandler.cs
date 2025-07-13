using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.BetaVideo.Queries.GetBetaVideosByRouteId;
public class GetBetaVideosByRouteIdQueryHandler(IBetaVideosRepository betaVideosRepository) 
    : IRequestHandler<GetBetaVideosByRouteIdQuery, List<Domain.Models.Entities.BetaVideo>>
{
    public async Task<List<Domain.Models.Entities.BetaVideo>> Handle(GetBetaVideosByRouteIdQuery query, CancellationToken cancellationToken)
    {
        var result = await betaVideosRepository.GetBetaVideosByRouteId(query.RouteId);

        return result;
    }
}
