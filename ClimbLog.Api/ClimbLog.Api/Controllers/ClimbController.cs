
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Domain.Models.SpResponses;
using Microsoft.AspNetCore.Mvc;
using MediatR;
using ClimbLog.Application.Features.ClimbLog.Queries.GetAllClimbLogs;
using ClimbLog.Application.Features.ClimbLog.Commands.LogClimb;
using ClimbLog.Api.Controllers.Base;
using ClimbLog.Application.Features.ClimbLog.Commands.UnlogClimb;
using ClimbLog.Application.Features.ClimbLog.Commands.UpdateClimbLog;
using ClimbLog.Application.Features.ClimbLog.Queries.GetClimbLogByRouteIdAndLoginId;

namespace ClimbLog.Api.Controllers;

public class ClimbController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [HttpGet("GetAllUserClimbs", Name = "GetAllUserClimbs")]
    public async Task<ActionResult<List<Domain.Models.Entities.ClimbLog>>> GetAllClimbs()
    {
        var climbs = await mediator.Send(new GetAllClimbLogsQuery { LoginId = HttpLoginId });
        return Ok(climbs);
    }

    [HttpPost("LogClimb")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> LogClimb([FromBody] LogClimbRequest request)
    {
        await mediator.Send(new LogClimbCommand
        {
            LoginId = HttpLoginId,
            RouteId = request.RouteId,
            DifficultyForGradeId = request.DifficultyForGradeId,
            AttemptCount = request.AttemptCount,
            Notes = request.Notes
        });

        return NoContent();
    }

    [HttpPatch("UpdateClimbLog")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> UpdateClimbLog([FromBody] UpdateClimbLogRequest request)
    {
        await mediator.Send(new UpdateClimbLogCommand
        {
            ClimbLogId = request.ClimbLogId,
            LoginId = HttpLoginId,
            DifficultyForGradeId = request.DifficultyForGradeId,
            AttemptCount = request.AttemptCount
        });

        return NoContent();
    }

    [HttpDelete("{routeId}/UnlogClimb")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> UnlogClimb([FromRoute] int routeId)
    {
        await mediator.Send(new UnlogClimbCommand
        {
            LoginId = HttpLoginId,
            RouteId = routeId
        });

        return NoContent();
    }

    [HttpGet("{routeId}/GetClimbLogByRouteId")]
    public async Task<ActionResult<Domain.Models.Entities.ClimbLog>> GetClimbLogById([FromRoute] int routeId)
    {
        var result = await mediator.Send(new GetClimbLogByRouteIdAndLoginIdQuery { LoginId = HttpLoginId, RouteId = routeId });

        return Ok(result);
    }
}
