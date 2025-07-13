using ClimbLog.Api.Controllers.Base;
using ClimbLog.Application.Features.Competitions.Commands.CreateCompetition;
using ClimbLog.Application.Features.Competitions.Commands.EnterCompetition;
using ClimbLog.Application.Features.Competitions.Commands.LeaveCompetition;
using ClimbLog.Application.Features.Competitions.Commands.StartCompetition;
using ClimbLog.Application.Features.Competitions.Queries.GetCompetitionGroupLeaderboard;
using ClimbLog.Application.Features.Competitions.Queries.GetCompetitionGroupsByCompetitionId;
using ClimbLog.Application.Features.Competitions.Queries.GetCompetitionsByGym;
using ClimbLog.Application.Features.Competitions.Queries.GetCompetitionsByLogin;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ClimbLog.Api.Controllers;
public class CompetitionController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [HttpPost("CreateCompetition")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> CreateCompetition([FromBody] CreateCompetitionRequest request)
    {
        await EnsureUserIsGymAdmin(request.GymNames);
        await mediator.Send(new CreateCompetitionCommand { Request = request });
        return NoContent();
    }

    [AllowAnonymous]
    [HttpGet("{gymName}/GetCompetitionsByGym")]
    public async Task<ActionResult<List<GetCompetitionByGymQueryReponse>>> GetCompetitionsByGym([FromRoute] string gymName)
    {
        var result = await mediator.Send(new GetCompetitionsByGymQuery { GymName = gymName, LoginId = HttpLoginId });
        return Ok(result);
    }

    [HttpGet("GetCompetitionsByLogin")]
    public async Task<ActionResult<List<Competition>>> GetCompetitionsByLogin()
    {
        var result = await mediator.Send(new GetCompetitionsByLoginQuery { LoginId = HttpLoginId });
        return Ok(result);
    }

    [HttpPost("EnterCompetition")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> EnterCompetition([FromBody] int competitionGroupId)
    {
        await mediator.Send(new EnterCompetitionCommand { CompetitionGroupId = competitionGroupId, LoginId = HttpLoginId });
        return NoContent();
    }

    [HttpGet("{id}/GetCompetitionGroups")]
    public async Task<List<GetCompetitionGroupsByCompetitionIdQueryResponse>> GetCompetitionGroups([FromRoute] int id)
    {
        var result = await mediator.Send(new GetCompetitionGroupsByCompetitionIdQuery { CompetitionId = id });

        return result;
    }

    [HttpDelete("{id}/LeaveCompetition")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> LeaveCompetition([FromRoute] int id)
    {
        await mediator.Send(new LeaveCompetitionCommand { CompetitionId = id, LoginId = HttpLoginId });
        return NoContent();
    }

    [HttpGet("{competitionGroupId}/GetCompetitionGroupLeaderboard")]
    public async Task<ActionResult<GetCompetitionGroupLeaderboardQueryResponse>> GetCompetitionGroupLeaderboard(int competitionGroupId)
    {
        var result = await mediator.Send(new GetCompetitionGroupLeaderboardQuery { CompetitionGroupId = competitionGroupId });
        return Ok(result);
    }

    [HttpPost("StartCompetition")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> StartCompetition([FromBody] int id)
    {
        await EnsureUserIsCompetitionAdmin(id);
        await mediator.Send(new StartCompetitionCommand { CompetitionId = id });
        return NoContent();
    }

    [HttpPost("StopCompetition")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> StopCompetition([FromBody] int id)
    {
        await EnsureUserIsCompetitionAdmin(id);
        await mediator.Send(new StopCompetitionCommand { CompetitionId = id });
        return NoContent();
    }

    [HttpPost("ArchiveCompetition")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> ArchiveCompetition([FromBody] int id)
    {
        await EnsureUserIsCompetitionAdmin(id);
        await mediator.Send(new ArchiveCompetitionCommand { CompetitionId = id });
        return NoContent();
    }
}
