using Amazon.Runtime.Internal;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Routes.Queries.GetInfoForUpsertingRoute;

public class GetInfoForUpsertingRouteQuery : IRequest<GetInfoForUpsertingRouteQueryResponse>
{
    public required string GymName { get; set; }
    public int? ExistingRouteId { get; set; }
}
