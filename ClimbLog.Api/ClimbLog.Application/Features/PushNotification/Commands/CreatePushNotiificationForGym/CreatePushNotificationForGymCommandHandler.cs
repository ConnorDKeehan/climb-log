using ClimbLog.Domain.Interfaces;
using MediatR;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.PushNotification.Commands.CreatePushNotiificationForGym;
public class CreatePushNotificationForGymCommandHandler(IStoredProceduresRepository storedProceduresRepository, IFirebaseService firebaseService) 
    : IRequestHandler<CreatePushNotificationForGymCommand, Unit>
{
    public async Task<Unit> Handle(CreatePushNotificationForGymCommand command, CancellationToken cancellationToken)
    {
        var tokens = await storedProceduresRepository.GetPushNotificationTokensByGymName(command.GymName);

        if (tokens.Count > 0)
        {
            await firebaseService.SendNotificationsAsync(tokens, command.Title, command.Body);
        }

        return Unit.Value;
    }
}
