using ClimbLog.Api.Controllers.Base;
using ClimbLog.Application.Features.Facilities.Queries.GetAllFacilities;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ClimbLog.Api.Controllers;


public class FacilityController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [AllowAnonymous]
    [HttpGet]
    public async Task<ActionResult<List<Facility>>> GetAllFacilities()
    {
        var result = await mediator.Send(new GetAllFacilitiesQuery());

        return Ok(result);
    }
}
