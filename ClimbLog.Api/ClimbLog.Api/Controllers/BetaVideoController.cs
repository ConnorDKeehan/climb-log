
using ClimbLog.Domain.Models.Entities;
using Microsoft.AspNetCore.Mvc;
using MediatR;
using ClimbLog.Api.Controllers.Base;
using Microsoft.AspNetCore.Authorization;
using ClimbLog.Application.Features.BetaVideo.Queries.GetBetaVideosByRouteId;

namespace ClimbLog.Api.Controllers;

public class BetaVideoController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [AllowAnonymous]
    [HttpGet("{routeId}/GetBetaVideos")]
    public async Task<ActionResult<List<BetaVideo>>> GetBetaVideos([FromRoute] int routeId)
    {
        var result = await mediator.Send(new GetBetaVideosByRouteIdQuery { RouteId = routeId });

        return Ok(result);
    }
}
