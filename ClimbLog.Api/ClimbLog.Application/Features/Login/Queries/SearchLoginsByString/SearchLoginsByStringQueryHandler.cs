using AutoMapper;
using ClimbLog.Application.Features.Logins.Queries.SearchLoginsByString;
using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Users.Queries.SearchUsersByString;
public class SearchLoginsByStringQueryHandler(ILoginsRepository loginsRepository, IMapper mapper, IGymsRepository gymsRepository) 
    : IRequestHandler<SearchLoginsByStringQuery, List<SearchLoginsByStringQueryResponse>>
{
    public async Task<List<SearchLoginsByStringQueryResponse>> Handle(SearchLoginsByStringQuery query, CancellationToken cancellationToken)
    {
        var gym = await gymsRepository.GetGymByName(query.GymName);
        var logins = await loginsRepository.SearchLoginsByString(query.SearchString, gym.Id);

        var result = mapper.Map<List<SearchLoginsByStringQueryResponse>>(logins);

        return result;
    }
}
