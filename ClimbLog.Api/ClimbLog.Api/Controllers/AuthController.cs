using ClimbLog.Application.Features.Auth.Commands.DeleteLogin;
using ClimbLog.Application.Features.Auth.Commands.Login;
using ClimbLog.Application.Features.Auth.Commands.LoginWithSocial;
using ClimbLog.Application.Features.Auth.Commands.RefreshAccessToken;
using ClimbLog.Application.Features.Auth.Responses;
using ClimbLog.Application.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace ClimbLog.Api.Controllers
{
    [ApiController]
    [AllowAnonymous]
    [Route("api/[controller]")]
    public class AuthController(IMediator mediator, IAuthService authService) : ControllerBase
    {
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto registerDto)
        {
            await authService.RegisterAsync(
                registerDto.Username.ToLower(), 
                registerDto.Email, 
                registerDto.Password, 
                registerDto.FriendlyName, 
                registerDto.PushNotificationToken
            );

            return Ok("User registered successfully.");
        }

        [HttpPost("login")]
        public async Task<ActionResult<AccessTokenResponse>> Login([FromBody] LoginCommand loginCommand)
        {
            var result = await mediator.Send(loginCommand);

            return Ok(result);
        }

        [HttpPost("RefreshAccessToken")]
        [Authorize]
        public async Task<ActionResult<AccessTokenResponse>> RefreshAccessToken([FromBody] string? pushNotificationToken)
        {
            var loginId = int.Parse(User.FindFirstValue("LoginId"));
            var result = await mediator.Send(new RefreshAccessTokenCommand { LoginId = loginId, PushNotificationToken = pushNotificationToken });
            return Ok(result);
        }

        [HttpPost("DeleteLogin")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public async Task<IActionResult> DeleteLogin(DeleteLoginCommand deleteLoginCommand)
        {
            await mediator.Send(deleteLoginCommand);

            return NoContent();
        }

        [HttpPost("LoginWithSocial")]
        public async Task<IActionResult> LoginWithSocial([FromBody] LoginWithSocialCommand command)
        {
            var token = await mediator.Send(command);
            return Ok(token);
        }
    }

    public class RegisterDto
    {
        public required string Username { get; set; }
        public string? Email { get; set; }
        public required string Password { get; set; }
        public string? FriendlyName { get; set; }
        public string? PushNotificationToken { get; set; } = null;
    }
}
