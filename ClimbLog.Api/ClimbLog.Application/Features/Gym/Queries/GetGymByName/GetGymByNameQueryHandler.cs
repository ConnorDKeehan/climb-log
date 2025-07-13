using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Gym.Queries.GetGymByName;

public class GetGymByNameQueryHandler(IGymsRepository gymsRepository) : IRequestHandler<GetGymByNameQuery, Domain.Models.Entities.Gym>
{
    public async Task<Domain.Models.Entities.Gym> Handle(GetGymByNameQuery query, CancellationToken cancellationToken = default)
    {
        var result = await gymsRepository.GetGymByName(query.Name);

        return result;
    }
}
