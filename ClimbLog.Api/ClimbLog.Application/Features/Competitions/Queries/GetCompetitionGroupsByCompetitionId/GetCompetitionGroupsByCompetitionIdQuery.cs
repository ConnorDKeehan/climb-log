using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Queries.GetCompetitionGroupsByCompetitionId;
public class GetCompetitionGroupsByCompetitionIdQuery : IRequest<List<GetCompetitionGroupsByCompetitionIdQueryResponse>>
{
    public int CompetitionId { get; set; }
}
