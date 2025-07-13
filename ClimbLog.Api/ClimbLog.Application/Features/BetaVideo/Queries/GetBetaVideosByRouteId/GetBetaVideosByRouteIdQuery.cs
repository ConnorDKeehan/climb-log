using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.BetaVideo.Queries.GetBetaVideosByRouteId;

public class GetBetaVideosByRouteIdQuery : IRequest<List<Domain.Models.Entities.BetaVideo>>
{
    public int RouteId { get; set; }
}
