using ClimbLog.Application.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Commands.Register;

public class RegisterCommandHandler(IAuthService authService) : IRequestHandler<RegisterCommand, Unit>
{
    public async Task<Unit> Handle(RegisterCommand command, CancellationToken cancellationToken = default)
    {
        await authService.RegisterAsync(command.Username, command.Email, command.Password, command.FriendlyName, command.PushNotificationToken);

        return Unit.Value;
    }
}
