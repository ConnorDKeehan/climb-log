using MediatR;

namespace ClimbLog.Application.Features.Gym.Queries.GetAllGymNames;

public class GetAllGymNamesQuery : IRequest<List<string>>
{
}
