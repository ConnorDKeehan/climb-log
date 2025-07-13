using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Sectors.Queries.GetSectorsByGymName;
public class GetSectorsByGymNameQueryHandler(
    IGymsRepository gymsRepository, 
    ISectorsRepository sectorsRepository) : IRequestHandler<GetSectorsByGymNameQuery, List<Sector>>
{
    public async Task<List<Sector>> Handle(GetSectorsByGymNameQuery query, CancellationToken cancellationToken)
    {
        var gym = await gymsRepository.GetGymByName(query.GymName);

        var result = await sectorsRepository.GetSectorsByGymId(gym.Id);

        return result;
    }
}
