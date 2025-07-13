using ClimbLog.Api.Controllers.Base;
using ClimbLog.Application.Features.Auth.Queries.CheckUserIsGymAdmin;
using ClimbLog.Application.Features.Auth.Queries.GetAllGymsWhereUserIsAdmin;
using ClimbLog.Application.Features.Facilities.Queries.GetFacilitiesToShow;
using ClimbLog.Application.Features.Grades.Queries.GetGymGradeNamesByGymName;
using ClimbLog.Application.Features.Gym.Commands.AddGymFacility;
using ClimbLog.Application.Features.Gym.Commands.DeleteGymFacility;
using ClimbLog.Application.Features.Gym.Commands.EditGymFacilities;
using ClimbLog.Application.Features.Gym.Commands.UpdateGymAddress;
using ClimbLog.Application.Features.Gym.Commands.UpsertDefaultGymOpeningHours;
using ClimbLog.Application.Features.Gym.Queries.GetAllGymNames;
using ClimbLog.Application.Features.Gym.Queries.GetGymAboutDetails;
using ClimbLog.Application.Features.Gym.Queries.GetGymByName;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ClimbLog.Api.Controllers;

public class GymController(IMediator mediator) : BaseClimbLogController(mediator)
{
    [AllowAnonymous]
    [HttpGet("GetAllGymNames")]
    public async Task<ActionResult<List<string>>> GetAllGymNames()
    {
        var result = await mediator.Send(new GetAllGymNamesQuery());
        return Ok(result);
    }

    [AllowAnonymous]
    [HttpGet("{gymName}/GetGymAboutDetails")]
    public async Task<ActionResult<GetGymAboutDetailsQueryResponse>> GetGymAboutDetails([FromRoute] string gymName)
    {
        var result = await mediator.Send(new GetGymAboutDetailsQuery { Name = gymName });

        return Ok(result);
    }

    [AllowAnonymous]
    [HttpGet("{gymName}/FacilitiesToShow")]
    public async Task<ActionResult<List<Facility>>> GetFacilitiesToShow([FromRoute] string gymName)
    {
        var result = await mediator.Send(new GetFacilitiesToShowQuery { GymName = gymName });

        return Ok(result);
    }

    [AllowAnonymous]
    [HttpGet("{gymName}/GetGym")]
    public async Task<ActionResult<Gym>> GetGym([FromRoute] string gymName)
    {
        var gym = await mediator.Send(new GetGymByNameQuery { Name = gymName });

        return Ok(gym);
    }

    [AllowAnonymous]
    [HttpGet("{gymName}/GetGymGrades")]
    public async Task<ActionResult<GetGymGradeNamesByGymNameQueryResponse>> GetGymGrades([FromRoute] string gymName)
    {
        var gymGrades = await mediator.Send(new GetGymGradeNamesByGymNameQuery { GymName = gymName });

        return Ok(gymGrades);
    }

    [AllowAnonymous]
    [HttpGet("{gymName}/IsUserGymAdmin")]
    public async Task<ActionResult<bool>> IsUserGymAdmin([FromRoute] string gymName)
    {
        var result = await mediator.Send(new CheckUserIsGymAdminQuery { GymName = [gymName], LoginId = HttpLoginId });

        return Ok(result);
    }

    //Everything below here should be admin only features
    [HttpPut("{gymName}/UpsertDefaultGymOpeningHours")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> UpsertDefaultGymOpeningHours([FromRoute] string gymName, [FromBody] List<OpeningHourRequest> request)
    {
        await EnsureUserIsGymAdmin(gymName);
        await mediator.Send(new UpsertDefaultGymOpeningHoursCommand { GymName = gymName, OpeningHours = request });

        return NoContent();
    }

    [HttpPost("{gymName}/AddGymFacility")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> AddGymFacility([FromRoute] string gymName, [FromBody] string facilityName)
    {
        await EnsureUserIsGymAdmin(gymName);

        await mediator.Send(new AddGymFacilityCommand { FacilityName = facilityName, GymName = gymName });

        return NoContent();
    }

    [HttpDelete("{gymName}/DeleteGymFacility")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> DeleteGymFacility([FromRoute] string gymName, [FromQuery] string facilityName)
    {
        await EnsureUserIsGymAdmin(gymName);

        await mediator.Send(new DeleteGymFacilityCommand { FacilityName = facilityName, GymName = gymName });

        return NoContent();
    }

    [HttpPut("{gymName}/UpdateGymAddress")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> UpdateGymAddress([FromRoute] string gymName, [FromBody] string gymAddress)
    {
        await EnsureUserIsGymAdmin(gymName);

        await mediator.Send(new UpdateGymAddressCommand { GymAddress = gymAddress, GymName = gymName });

        return NoContent();
    }

    [HttpPut("{gymName}/EditGymFacilities")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> EditGymFacilities([FromRoute] string gymName, [FromBody] List<int> facilityIds)
    {
        await EnsureUserIsGymAdmin(gymName);

        await mediator.Send(new EditGymFacilitiesCommand { GymName = gymName, FacilityIds = facilityIds });
        return NoContent();
    }

    [HttpGet("GetAllGymsWhereUserIsAdmin")]
    public async Task<ActionResult<List<string>>> GetAllGymsWhereUserIsAdmin()
    {
        var result = await mediator.Send(new GetAllGymsWhereUserIsAdminQuery { LoginId = HttpLoginId });

        return Ok(result);
    }
}
