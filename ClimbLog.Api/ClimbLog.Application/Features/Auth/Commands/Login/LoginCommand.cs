using ClimbLog.Application.Features.Auth.Responses;
using MediatR;

namespace ClimbLog.Application.Features.Auth.Commands.Login;

public class LoginCommand : IRequest<AccessTokenResponse>
{
    public required string Username { get; set; }
    public required string Password { get; set; }
    public string? PushNotificationToken { get; set; }
}
