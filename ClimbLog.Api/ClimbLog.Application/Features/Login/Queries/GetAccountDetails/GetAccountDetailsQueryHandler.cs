using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Login.Queries.GetAccountDetails;

public class GetAccountDetailsQueryHandler(ILoginsRepository loginsRepository) : IRequestHandler<GetAccountDetailsQuery, GetAccountDetailsQueryResponse>
{
    public async Task<GetAccountDetailsQueryResponse> Handle(GetAccountDetailsQuery query, CancellationToken cancellationToken)
    {
        var login = await loginsRepository.GetLoginById(query.LoginId);

        var result = new GetAccountDetailsQueryResponse
        {
            Email = login.Email,
            FriendlyName = login.FriendlyName,
            UserName = login.Username,
            ProfilePictureUrl = login.ProfilePictureUrl,
            BioText = login.BioText,
            DateCreated = login.DateCreatedUtc?.ToLocalTime().ToShortDateString(),
        };

        return result;
    }
}
