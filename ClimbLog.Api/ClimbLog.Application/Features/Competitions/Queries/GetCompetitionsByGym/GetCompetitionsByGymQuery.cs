using Amazon.Runtime.Internal;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Competitions.Queries.GetCompetitionsByGym;
public class GetCompetitionsByGymQuery : IRequest<List<GetCompetitionByGymQueryReponse>>
{
    public required string GymName { get; set; }
    public int LoginId { get; set; }
}
