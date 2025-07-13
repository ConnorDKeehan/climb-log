using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Routes.Queries.GetRouteInfo;
public class GetRouteInfoQuery : IRequest<GetRouteInfoQueryResponse>
{
    public int Id { get; set; }
}
