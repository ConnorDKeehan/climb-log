using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Queries.GetCompetitionsByLogin;
public class GetCompetitionsByLoginQuery : IRequest<List<Competition>>
{
    public int LoginId { get; set; }
}
