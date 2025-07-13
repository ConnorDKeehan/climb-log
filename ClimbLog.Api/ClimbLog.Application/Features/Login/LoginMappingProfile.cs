using ClimbLog.Domain.Models.Entities;
using AutoMapper;
using ClimbLog.Application.Features.Logins.Queries.SearchLoginsByString;
using ClimbLog.Domain.Models.RepoResponses;

namespace ClimbLog.Application.Features.Logins;
public class LoginMappingProfile : Profile
{
    public LoginMappingProfile()
    {
        CreateMap<SearchLoginsByStringResponse, SearchLoginsByStringQueryResponse>()
            .ForMember(x => x.DisplayName, opt => opt.MapFrom(x => x.FriendlyName ?? x.Username));
    }
}
