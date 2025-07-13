using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Commands.StartCompetition;
public class ArchiveCompetitionCommand : IRequest<Unit>
{
    public int CompetitionId { get; set; }
}
