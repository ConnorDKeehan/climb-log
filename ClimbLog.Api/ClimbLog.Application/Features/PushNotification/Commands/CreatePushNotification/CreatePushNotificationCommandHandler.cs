using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.PushNotification.Commands.CreatePushNotification;
public class CreatePushNotificationCommandHandler(IFirebaseService firebaseService) : IRequestHandler<CreatePushNotificationCommand, Unit>
{
    public async Task<Unit> Handle(CreatePushNotificationCommand command, CancellationToken cancellationToken)
    {
        await firebaseService.SendNotificationsAsyncByLoginId(command.LoginId, command.Title, command.Body);

        return Unit.Value;
    }
}
