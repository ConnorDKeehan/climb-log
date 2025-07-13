using ClimbLog.Api.Controllers.Base;
using ClimbLog.Application.Features.Grades.Queries.GetGymGradeNamesByGymName;
using ClimbLog.Application.Features.Grades.Queries.GetGymGradesByGymName;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ClimbLog.Api.Controllers;

public class GradeController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [AllowAnonymous]
    [HttpGet("{gymName}/GetGymGrades")]
    public async Task<ActionResult<GetGymGradesByGymNameResponse>> GetGymGrades([FromRoute] string gymName)
    {
        var result = await mediator.Send(new GetGymGradesByGymNameQuery { GymName = gymName });

        return Ok(result);
    }
}
