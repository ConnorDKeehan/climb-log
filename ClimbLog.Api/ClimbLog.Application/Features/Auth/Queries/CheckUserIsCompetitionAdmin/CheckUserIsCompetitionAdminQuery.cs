using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Queries.CheckUserIsCompetitionAdmin;
public class CheckUserIsCompetitionAdminQuery : IRequest<bool>
{
    public int CompetitionId { get; set; }
    public int LoginId { get; set; }
}
