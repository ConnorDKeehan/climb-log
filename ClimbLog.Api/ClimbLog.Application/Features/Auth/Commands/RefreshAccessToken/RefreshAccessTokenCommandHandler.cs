using ClimbLog.Application.Features.Auth.Responses;
using ClimbLog.Application.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Commands.RefreshAccessToken;

public class RefreshAccessTokenCommandHandler(IAuthService authService) : IRequestHandler<RefreshAccessTokenCommand, AccessTokenResponse>
{
    public async Task<AccessTokenResponse> Handle(RefreshAccessTokenCommand command, CancellationToken cancellationToken = default)
    {
        var result = await authService.RefreshToken(command.LoginId, command.PushNotificationToken);

        return new AccessTokenResponse { Token = result };
    }
}
