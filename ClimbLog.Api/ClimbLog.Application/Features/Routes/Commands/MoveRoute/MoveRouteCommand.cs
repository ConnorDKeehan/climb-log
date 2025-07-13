using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Routes.Commands.MoveRoute;
public class MoveRouteCommand : IRequest<Unit>
{
    public int RouteId { get; set; }
    public decimal XCord { get; set; }
    public decimal YCord { get; set; }
}
