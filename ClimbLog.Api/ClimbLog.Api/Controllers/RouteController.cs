
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Domain.Models.SpResponses;
using ClimbLog.Api.Requests;
using Microsoft.AspNetCore.Mvc;
using MediatR;
using ClimbLog.Application.Features.Routes.Queries.GetAllCurrentRoutesByGymAndUser;
using ClimbLog.Application.Features.Routes.Commands.OldAddRoute;
using ClimbLog.Application.Features.Routes.Commands.ArchiveRoute;
using ClimbLog.Application.Features.Routes.Commands.ArchiveRoutes;
using ClimbLog.Api.Controllers.Base;
using ClimbLog.Application.Features.Auth.Queries.CheckUserIsGymAdmin;
using ClimbLog.Application.Features.Routes.Queries.GetRouteInfo;
using Microsoft.AspNetCore.Authorization;
using ClimbLog.Application.Features.Routes.Commands.MoveRoute;
using ClimbLog.Application.Features.Routes.Commands.EditRoute;
using ClimbLog.Application.Features.Routes.Queries.GetInfoForUpsertingRoute;
using ClimbLog.Application.Features.Routes.Commands.AddRoute;
using ClimbLog.Application.Features.Routes.Commands.BulkAlterCompetition;

namespace ClimbLog.Api.Controllers;

public class RouteController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [AllowAnonymous]
    [HttpGet("{gymName}/GetAllRoutes")]
    public async Task<ActionResult<List<GetAllCurentRoutesByGymAndUserSpResponse>>> GetAllCurrentRoutesByGymAndUser([FromRoute] string gymName)
    {
        var routes = await mediator.Send(new GetAllCurrentRoutesByGymAndUserQuery { GymName = gymName, LoginId = HttpLoginId });
        return Ok(routes);
    }

    [Obsolete("This will be killed soon. Just keep alive until 30/04/2025 to service old versions.")]
    [HttpPost("{gymName}/AddRoute")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> AddRoute([FromBody] AddRouteRequest addRouteRequest, [FromRoute] string gymName)
    {
        await EnsureUserIsGymAdmin(gymName);
        await mediator.Send(
            new OldAddRouteCommand
            {
                GymName = gymName,
                XCord = addRouteRequest.XCord,
                YCord = addRouteRequest.YCord,
                Grade = addRouteRequest.Grade,
                StandardGrade = addRouteRequest.StandardGrade,
                CompetitionId = addRouteRequest.CompetitionId,
                PointValue = addRouteRequest.PointValue,
                SectorId = addRouteRequest.SectorId
            });

        return NoContent();
    }

    [HttpPost("{gymName}/v2/AddRoute")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> V2AddRoute([FromBody] AddRouteCommand command, [FromRoute] string gymName)
    {
        await EnsureUserIsGymAdmin(gymName);
        await mediator.Send(command);

        return NoContent();
    }

    [HttpPost("{gymName}/EditRoute")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> EditRoute([FromBody] EditRouteCommand command,  [FromRoute] string gymName)
    {
        await EnsureUserIsGymAdmin(gymName);
        await mediator.Send(command);

        return NoContent();
    }

    [HttpPost("{gymName}/ArchiveRoute")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> ArchiveRoute([FromBody] int routeId, [FromRoute] string gymName)
    {
        await EnsureUserIsGymAdmin(gymName);
        await mediator.Send(new ArchiveRouteCommand { Id = routeId });
        return NoContent();
    }

    [HttpPost("{gymName}/ArchiveRoutes")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> ArchiveRoutes([FromBody] List<int> routeIds, [FromRoute] string gymName)
    {
        await EnsureUserIsGymAdmin(gymName);
        await mediator.Send(new ArchiveRoutesCommand { Ids = routeIds });

        return NoContent();
    }

    [HttpPost("{gymName}/MoveRoute")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> MoveRoute([FromBody] MoveRouteCommand command, [FromRoute] string gymName)
    {
        await EnsureUserIsGymAdmin(gymName);
        await mediator.Send(command);

        return NoContent();
    }

    [HttpPost("{gymName}/BulkAlterCompetition")]
    public async Task<IActionResult> BulkAlterCompetition([FromBody] BulkAlterCompetitionCommand request, [FromRoute] string gymName)
    {
        await EnsureUserIsGymAdmin(gymName);
        await mediator.Send(new BulkAlterCompetitionCommand { CompetitionId = request.CompetitionId, RouteIds = request.RouteIds });
        return NoContent();
    }

    [HttpGet("{gymName}/IsUserGymAdmin")]
    public async Task<ActionResult<bool>> IsUserGymAdmin([FromRoute] string gymName)
    {
        var result = await mediator.Send(new CheckUserIsGymAdminQuery { GymName = [gymName], LoginId = HttpLoginId });

        return Ok(result);
    }

    [AllowAnonymous]
    [HttpGet("{id}/GetRouteInfo")]
    public async Task<ActionResult<GetRouteInfoQueryResponse>> GetRouteInfo([FromRoute] int id)
    {
        var result = await mediator.Send(new GetRouteInfoQuery { Id = id });
        return Ok(result);
    }

    [AllowAnonymous]
    [HttpGet("{gymName}/GetInfoForAlteringRoute")] //This was poor naming, it should be upsert. Delete this one when sufficiently far from release.
    [HttpGet("{gymName}/GetInfoForUpsertingRoute")]
    public async Task<ActionResult<GetInfoForUpsertingRouteQueryResponse>> GetInfoForAlteringRoute([FromRoute] string gymName, [FromQuery] int? existingRouteId = null)
    {
        var result = await mediator.Send(
            new GetInfoForUpsertingRouteQuery { GymName = gymName , ExistingRouteId = existingRouteId});

        return Ok(result);
    }
}
