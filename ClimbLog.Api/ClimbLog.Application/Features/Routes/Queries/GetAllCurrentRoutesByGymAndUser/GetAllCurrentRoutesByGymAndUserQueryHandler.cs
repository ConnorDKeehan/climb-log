using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.SpResponses;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Routes.Queries.GetAllCurrentRoutesByGymAndUser;

public class GetAllCurrentRoutesByGymAndUserQueryHandler(IStoredProceduresRepository storedProceduresRepository)
    : IRequestHandler<GetAllCurrentRoutesByGymAndUserQuery, List<GetAllCurentRoutesByGymAndUserSpResponse>>
{
    public async Task<List<GetAllCurentRoutesByGymAndUserSpResponse>> Handle(GetAllCurrentRoutesByGymAndUserQuery query, 
        CancellationToken cancellationToken = default)
    {
        var result = await storedProceduresRepository.GetAllCurrentRoutesByGymAndUser(query.GymName, query.LoginId);

        return result;
    }
}
