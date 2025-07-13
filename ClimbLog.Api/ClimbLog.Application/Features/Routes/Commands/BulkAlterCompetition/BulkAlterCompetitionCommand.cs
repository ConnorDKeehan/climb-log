using Amazon.Runtime.Internal;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Routes.Commands.BulkAlterCompetition;

public class BulkAlterCompetitionCommand : IRequest<Unit>
{
    public required List<int> RouteIds { get; set; }
    public required int CompetitionId { get; set; }
}
