using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Queries.CheckUserIsCompetitionAdmin;
public class CheckUserIsCompetitionAdminQueryHandler(IGymsRepository gymsRepository) : IRequestHandler<CheckUserIsCompetitionAdminQuery, bool>
{
    public async Task<bool> Handle(CheckUserIsCompetitionAdminQuery query, CancellationToken cancellationToken)
    {
        var result = await gymsRepository.IsUserACompetitionAdmin(query.CompetitionId, query.LoginId);

        return result;
    }
}
