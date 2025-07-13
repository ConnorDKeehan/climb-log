using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Routes.Commands.ArchiveRoutes;

public class ArchiveRoutesCommand : IRequest<Unit>
{
    public List<int> Ids { get; set; }
}
