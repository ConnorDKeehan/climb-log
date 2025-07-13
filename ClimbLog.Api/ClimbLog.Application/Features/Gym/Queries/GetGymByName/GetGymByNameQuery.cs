using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Gym.Queries.GetGymByName;

public class GetGymByNameQuery : IRequest<Domain.Models.Entities.Gym>
{
    public string Name { get; set; }
}
