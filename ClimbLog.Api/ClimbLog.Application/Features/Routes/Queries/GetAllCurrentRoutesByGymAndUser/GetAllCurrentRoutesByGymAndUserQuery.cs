using ClimbLog.Domain.Models.SpResponses;
using MediatR;

namespace ClimbLog.Application.Features.Routes.Queries.GetAllCurrentRoutesByGymAndUser
{
    public class GetAllCurrentRoutesByGymAndUserQuery : IRequest<List<GetAllCurentRoutesByGymAndUserSpResponse>>
    {
        public required string GymName { get; set; }
        public int LoginId { get; set; }
    }
}
