using ClimbLog.Api.Controllers.Base;
using ClimbLog.Application.Features.GymAdmins.Commands.AddGymAdmin;
using ClimbLog.Application.Features.GymAdmins.Commands.RemoveGymAdmin;
using ClimbLog.Application.Features.Logins.Queries.SearchLoginsByString;
using ClimbLog.Application.Features.Users.Queries.SearchUsersByString;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ClimbLog.Api.Controllers;
public class AdminController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [HttpGet("{gymName}/SearchLoginsByString")]
    public async Task<ActionResult<List<SearchLoginsByStringQueryResponse>>> SearchLoginsByString([FromRoute] string gymName, [FromQuery] string searchString)
    {
        var result = await mediator.Send(new SearchLoginsByStringQuery { SearchString = searchString, GymName = gymName });
        return Ok(result);
    }

    [HttpPost("{gymName}/AddGymAdmin")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> AddGymAdmin([FromBody] int loginId, [FromRoute] string gymName)
    {
        await EnsureUserIsGymAdmin(gymName);
        var result = await mediator.Send(new AddGymAdminCommand { GymName = gymName, LoginId = loginId });

        return NoContent();
    }

    [HttpPost("{gymName}/RemoveGymAdmin")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> RemoveGymAdmin([FromBody] int loginId, [FromRoute] string gymName)
    {
        await EnsureUserIsGymAdmin(gymName);
        var result = await mediator.Send(new RemoveGymAdminCommand { GymName = gymName, LoginId = loginId });

        return NoContent();
    }
}
