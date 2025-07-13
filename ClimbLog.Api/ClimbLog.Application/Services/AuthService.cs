using ClimbLog.Application.Interfaces;
using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ClimbLog.Api.Services;

public class AuthService(IConfiguration configuration, ILoginsRepository loginsRepository) : IAuthService
{
    public async Task RegisterAsync(string username, string? email, string password, string? friendlyName, string? pushNotificationToken)
    {
        //Prevent whitespace submissions
        if (string.IsNullOrWhiteSpace(email))
        {
            email = null;
        }

        //No Email is acceptable but can't reuse an email as it will break SSO
        if (await loginsRepository.DoesThisUserAlreadyExist(username, email))
        {
            throw new ArgumentException("Username already taken");
        }

        var hashedPassword = BCrypt.Net.BCrypt.HashPassword(password);

        var login = new Login { 
            Username = username, 
            Email = email, 
            Password = hashedPassword,
            FriendlyName = friendlyName, 
            PushNotificationToken = pushNotificationToken,
            DateCreatedUtc = DateTime.UtcNow
        };

        await loginsRepository.AddLogin(login);
    }

    public async Task<string> LoginAsync(string username, string password, string? pushNotificationToken = null)
    {
        var login = await loginsRepository.GetLoginByUsername(username);

        if (login == null || !BCrypt.Net.BCrypt.Verify(password, login.Password))
        {
            throw new ArgumentException($"Invalid username or password.");
        }

        if(pushNotificationToken != null)
        {
            await loginsRepository.UpdatePushNotificationToken(login.Id, pushNotificationToken);
        }
            
        return GenerateJwtToken(login);
    }

    public async Task<string> RefreshToken(int loginId, string? pushNotificationToken)
    {
        var login = await loginsRepository.GetLoginById(loginId);

        if (!string.IsNullOrWhiteSpace(pushNotificationToken))
        {
            await loginsRepository.UpdatePushNotificationToken(login.Id, pushNotificationToken);
        }

        return GenerateJwtToken(login);
    }

    public string GenerateJwtToken(Login user)
    {
        var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration["Jwt:Key"]));
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

        var claims = new[]
        {
            new Claim(JwtRegisteredClaimNames.Sub, user.Username),
            new Claim(JwtRegisteredClaimNames.Email, user.Email ?? ""),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
            new Claim("LoginId", user.Id.ToString())
        };

        var token = new JwtSecurityToken(
            configuration["Jwt:Issuer"],
            configuration["Jwt:Issuer"],
            claims,
            expires: DateTime.Now.AddMonths(3),
            signingCredentials: credentials);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
