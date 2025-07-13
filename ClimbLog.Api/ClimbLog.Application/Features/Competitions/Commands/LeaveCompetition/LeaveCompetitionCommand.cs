using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Commands.LeaveCompetition;
public class LeaveCompetitionCommand : IRequest<Unit>
{
    public int CompetitionId { get; set; }
    public int LoginId { get; set; }
}
