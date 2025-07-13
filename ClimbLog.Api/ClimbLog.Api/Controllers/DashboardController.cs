using ClimbLog.Application.Interfaces;
using ClimbLog.Api.Responses;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using ClimbLog.Api.Controllers.Base;
using MediatR;
using Microsoft.AspNetCore.Components.Forms;
using ClimbLog.Domain.Models.SpResponses;
using ClimbLog.Application.Features.Reporting.Queries.GetAscentsGroupedByGradeByDate;
using ClimbLog.Application.Features.Reporting.Queries.GetMainDataView;
using ClimbLog.Domain.Models.Views;
using ClimbLog.Application.Features.Reporting.Queries.GetCurrentWeekPoints;

namespace ClimbLog.Api.Controllers;

public class DashboardController(IDashboardService dashboardService, IMediator mediator) : BaseClimbLogController(mediator)
{
    [HttpGet("{gymName}/GetPersonalStats")]
    public async Task<ActionResult<GetPersonalStatsByGymResponse>> GetPersonalStats([FromRoute] string gymName)
    {
        var result = await dashboardService.GetPersonalStatsByGym(gymName, HttpLoginId);
        return Ok(result);
    }

    [HttpGet("{gymName}/GetMainDataView")]
    public async Task<ActionResult<List<vwMainData>>> GetMainDataView([FromRoute] string gymName)
    {
        var result = await mediator.Send(new GetMainDataViewQuery { GymName = gymName, LoginId = HttpLoginId });

        return Ok(result);
    }

    [HttpGet("{gymName}/GetAscentsGroupedByGradeByDate")]
    public async Task<ActionResult<List<GetAscentsGroupedByGradeByDateSpResponse>>> GetAscentsGroupedByGradeByDate([FromRoute] string gymName)
    {
        var result = await mediator.Send(new GetAscentsGroupedByGradeByDateQuery { GymName = gymName, LoginId = HttpLoginId });

        return Ok(result);
    }

    [HttpGet("{gymName}/GetPointsDataView")]
    public async Task<ActionResult<List<GetCurrentWeekPointsResponse>>> GetPointsDataView([FromRoute] string gymName)
    {
        var result = await mediator.Send(new GetCurrentWeekPointsQuery { GymName = gymName});

        return Ok(result);
    }

    [HttpGet("{gymName}/GetNumOfClimbsDataView")]
    public async Task<ActionResult<List<GetCurrentNumOfClimbsResponse>>> GetNumOfClimbsDataView([FromRoute] string gymName)
    {
        var result = await mediator.Send(new GetCurrentNumOfClimbsQuery { GymName = gymName });

        return Ok(result);
    }
}
