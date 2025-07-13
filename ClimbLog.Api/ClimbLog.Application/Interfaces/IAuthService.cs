using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Application.Interfaces
{
    public interface IAuthService
    {
        string GenerateJwtToken(Login user);
        Task<string> LoginAsync(string username, string password, string? pushNotificationToken = null);
        Task<string> RefreshToken(int loginId, string? pushNotificationToken);
        Task RegisterAsync(string username, string? email, string password, string? friendlyName, string? pushNotificationToken);
    }
}