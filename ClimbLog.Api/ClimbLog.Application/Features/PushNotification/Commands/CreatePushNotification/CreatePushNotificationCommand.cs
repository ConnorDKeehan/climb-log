using MediatR;

namespace ClimbLog.Application.Features.PushNotification.Commands.CreatePushNotification;
public class CreatePushNotificationCommand : IRequest<Unit>
{
    public required string Title { get; set; }
    public required string Body { get; set; }
    public int LoginId { get; set; }
}
