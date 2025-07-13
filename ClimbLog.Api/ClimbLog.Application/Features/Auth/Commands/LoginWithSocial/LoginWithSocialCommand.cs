using MediatR;

namespace ClimbLog.Application.Features.Auth.Commands.LoginWithSocial;
public class LoginWithSocialCommand : IRequest<string>
{
    public required string Provider {  get; set; }
    public required string IdToken {  get; set; }
    public string? FriendlyName { get; set; }
    public string? PushNotificationToken { get; set; }
}
