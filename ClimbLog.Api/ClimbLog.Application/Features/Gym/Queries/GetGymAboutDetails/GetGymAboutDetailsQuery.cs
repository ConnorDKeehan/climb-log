using MediatR;

namespace ClimbLog.Application.Features.Gym.Queries.GetGymAboutDetails;

public class GetGymAboutDetailsQuery : IRequest<GetGymAboutDetailsQueryResponse>
{
    public string Name { get; set; }
}
