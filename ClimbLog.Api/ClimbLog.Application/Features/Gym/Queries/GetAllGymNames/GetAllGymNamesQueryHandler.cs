using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Gym.Queries.GetAllGymNames;

public class GetAllGymNamesQueryHandler(IGymsRepository gymsRepository) : IRequestHandler<GetAllGymNamesQuery, List<string>>
{
    public async Task<List<string>> Handle(GetAllGymNamesQuery query, CancellationToken cancellationToken = default)
    {
        var result = (await gymsRepository.GetAllGyms()).Select(x => x.Name).ToList();
        return result;
    }
}
