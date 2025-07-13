using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Queries.GetAllGymsWhereUserIsAdmin;
public class GetAllGymsWhereUserIsAdminQueryHandler(IGymsRepository gymsRepository) 
    : IRequestHandler<GetAllGymsWhereUserIsAdminQuery, List<string>>
{
    public async Task<List<string>> Handle(GetAllGymsWhereUserIsAdminQuery query, CancellationToken cancellationToken = default)
    {
        var gymNames = await gymsRepository.GetGymNamesByGymAdmin(query.LoginId);

        return gymNames;
    }
}
