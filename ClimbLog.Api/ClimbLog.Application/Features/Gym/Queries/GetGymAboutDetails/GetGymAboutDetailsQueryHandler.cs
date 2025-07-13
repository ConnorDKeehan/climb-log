using AutoMapper;
using ClimbLog.Application.Features.Gym.Queries.GetGymAboutDetails.Models;
using ClimbLog.Domain.Interfaces;
using MediatR;
using System.Linq;

namespace ClimbLog.Application.Features.Gym.Queries.GetGymAboutDetails;

public class GetGymAboutDetailsQueryHandler(IGymsRepository gymsRepository, IMapper mapper) 
    : IRequestHandler<GetGymAboutDetailsQuery, GetGymAboutDetailsQueryResponse>
{
    public async Task<GetGymAboutDetailsQueryResponse> Handle(GetGymAboutDetailsQuery query, CancellationToken cancellationToken = default)
    {
        var gymDetails = await gymsRepository.GetGymAboutDetailsByName(query.Name);
        var result = mapper.Map<GetGymAboutDetailsQueryResponse>(gymDetails);

        var daysOfWeek = Enum.GetValues(typeof(DayOfWeek)).Cast<string>();

        return result;
    }
}
