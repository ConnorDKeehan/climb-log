using ClimbLog.Api.Controllers.Base;
using ClimbLog.Application.Features.PushNotification.Commands.CreatePushNotification;
using ClimbLog.Application.Features.PushNotification.Commands.CreatePushNotiificationForGym;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ClimbLog.Api.Controllers;
public class PushNotificationController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [HttpPost("CreatePushNotification")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> CreatePushNotificationForSelf(string title, string body)
    {
        await mediator.Send(new CreatePushNotificationCommand { Title = title, Body = body, LoginId = HttpLoginId });

        return NoContent();
    }

    [HttpPost("CreatePushNotificationByGymName")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> CreatePushNotificationByGymName([FromBody] CreatePushNotificationForGymCommand command)
    {
        await EnsureUserIsGymAdmin(command.GymName);

        await mediator.Send(command);

        return NoContent();
    }
}
