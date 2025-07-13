using Amazon.Runtime.Internal;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Commands.EnterCompetition;
public class EnterCompetitionCommand : IRequest<Unit>
{
    public int LoginId { get; set; }
    public int CompetitionGroupId { get; set; }
}
