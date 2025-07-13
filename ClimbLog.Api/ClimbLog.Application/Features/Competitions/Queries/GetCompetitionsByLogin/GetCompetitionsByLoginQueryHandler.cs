using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Queries.GetCompetitionsByLogin;
public class GetCompetitionsByLoginQueryHandler(
        ICompetitionGroupLoginsRepository competitionGroupLoginsRepository,
        ICompetitionsRepository competitionsRepository
    ) : IRequestHandler<GetCompetitionsByLoginQuery, List<Competition>>
{
    public async Task<List<Competition>> Handle(GetCompetitionsByLoginQuery query, CancellationToken cancellationToken)
    {
        var competitionGroupIds = await competitionGroupLoginsRepository.GetCompetitionGroupIdsFromLoginId(query.LoginId);

        var result = await competitionsRepository.GetCompetitionsByCompetitionGroupIds(competitionGroupIds);

        return result;
    }
}
