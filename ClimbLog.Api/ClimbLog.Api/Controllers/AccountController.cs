using ClimbLog.Api.Controllers.Base;
using ClimbLog.Application.Features.GymAdmins.Commands.AddGymAdmin;
using ClimbLog.Application.Features.GymAdmins.Commands.RemoveGymAdmin;
using ClimbLog.Application.Features.Login.Commands.EditAccountDetails;
using ClimbLog.Application.Features.Login.Commands.UpdateProfilePicture;
using ClimbLog.Application.Features.Login.Queries.GetAccountDetails;
using ClimbLog.Application.Features.Logins.Queries.SearchLoginsByString;
using ClimbLog.Application.Features.Users.Queries.SearchUsersByString;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ClimbLog.Api.Controllers;
public class AccountController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [HttpGet("GetAccountDetails")]
    public async Task<ActionResult<GetAccountDetailsQueryResponse>> GetAccountDetails()
    {
        var result = await mediator.Send(new GetAccountDetailsQuery { LoginId = HttpLoginId });

        return Ok(result);
    }

    [HttpPost("EditAccountDetails")]
    public async Task<IActionResult> EditAccountDetails([FromBody] EditAccountDetailsRequest request)
    {
        await mediator.Send(new EditAccountDetailsCommand { LoginId = HttpLoginId, FriendlyName = request.FriendlyName, BioText = request.BioText });

        return NoContent();
    }

    [HttpPost("UpdateProfilePicture")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> UpdateProfilePicture(IFormFile profilePicture)
    {
        await mediator.Send(new UpdateProfilePictureCommand { LoginId = HttpLoginId, profilePicture = profilePicture });
        return NoContent();
    }
}
