using ClimbLog.Application.Features.Auth.Responses;
using ClimbLog.Application.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Commands.Login;

public class LoginCommandHandler(IAuthService authService) : IRequestHandler<LoginCommand, AccessTokenResponse>
{
    public async Task<AccessTokenResponse> Handle(LoginCommand command, CancellationToken cancellationToken = default)
    {
        var result = await authService.LoginAsync(command.Username, command.Password, command.PushNotificationToken);

        return new AccessTokenResponse { Token = result };
    }
}
