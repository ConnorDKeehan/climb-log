using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.PushNotification.Commands.CreatePushNotiificationForGym;
public class CreatePushNotificationForGymCommand : IRequest<Unit>
{
    public required string Title { get; set; }
    public required string Body { get; set; }
    public required string GymName { get; set; }
}
