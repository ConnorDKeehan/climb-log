using Amazon.Runtime.Internal;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Commands.CreateCompetition;
public class CreateCompetitionCommand : IRequest<Unit>
{
    public required CreateCompetitionRequest Request { get; set; }
}
