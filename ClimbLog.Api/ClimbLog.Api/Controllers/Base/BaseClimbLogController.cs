using ClimbLog.Application.Features.Auth.Queries.CheckUserIsCompetitionAdmin;
using ClimbLog.Application.Features.Auth.Queries.CheckUserIsGymAdmin;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace ClimbLog.Api.Controllers.Base;

[ApiController]
[Authorize]
[Route("[controller]")]
public abstract class BaseClimbLogController(IMediator mediator) : ControllerBase
{
    protected int HttpLoginId => int.Parse(User.FindFirstValue("LoginId") ?? "0");

    protected async Task EnsureUserIsGymAdmin(string gymName)
    {
        var isAdmin = await mediator.Send(new CheckUserIsGymAdminQuery { GymName = [gymName], LoginId = HttpLoginId });

        if (!isAdmin)
            throw new UnauthorizedAccessException("User is not an admin for this gym");
    }

    protected async Task EnsureUserIsGymAdmin(List<string> gymName)
    {
        var isAdmin = await mediator.Send(new CheckUserIsGymAdminQuery { GymName = gymName, LoginId = HttpLoginId });

        if (!isAdmin)
            throw new UnauthorizedAccessException("User is not an admin for this gym");
    }

    protected async Task EnsureUserIsCompetitionAdmin(int competitionId)
    {
        var isAdmin = await mediator.Send(new CheckUserIsCompetitionAdminQuery { CompetitionId = competitionId, LoginId = HttpLoginId });

        if(!isAdmin)
            throw new UnauthorizedAccessException("User is not an admin for this comp");
    }
}