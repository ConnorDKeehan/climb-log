using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.ClimbLog.Queries.GetClimbLogByRouteIdAndLoginId;
public class GetClimbLogByRouteIdAndLoginIdQuery : IRequest<Domain.Models.Entities.ClimbLog>
{
    public int RouteId { get; set; }
    public int LoginId { get; set; }
}
