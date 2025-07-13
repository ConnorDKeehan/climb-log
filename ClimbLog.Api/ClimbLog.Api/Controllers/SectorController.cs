
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Domain.Models.SpResponses;
using Microsoft.AspNetCore.Mvc;
using MediatR;
using ClimbLog.Api.Controllers.Base;
using ClimbLog.Application.Features.Sectors.Queries.GetSectorsByGymName;
using Microsoft.AspNetCore.Authorization;

namespace ClimbLog.Api.Controllers;


public class SectorController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [AllowAnonymous]
    [HttpGet("{gymName}/GetSectorsByGymName")]
    public async Task<ActionResult<List<Sector>>> GetSectorsByGymName([FromRoute] string gymName)
    {
        var result = await mediator.Send(new GetSectorsByGymNameQuery { GymName = gymName});

        return Ok(result);
    }
}
