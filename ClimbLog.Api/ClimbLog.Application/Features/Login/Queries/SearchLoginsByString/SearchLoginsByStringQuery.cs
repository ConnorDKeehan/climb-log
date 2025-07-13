using ClimbLog.Application.Features.Logins.Queries.SearchLoginsByString;
using MediatR;

namespace ClimbLog.Application.Features.Users.Queries.SearchUsersByString;
public class SearchLoginsByStringQuery : IRequest<List<SearchLoginsByStringQueryResponse>>
{
    public required string SearchString { get; set; }
    public required string GymName { get; set; }
}
