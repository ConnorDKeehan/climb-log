using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Sectors.Queries.GetSectorsByGymName;

public class GetSectorsByGymNameQuery : IRequest<List<Sector>>
{
    public required string GymName { get; set; }
}
