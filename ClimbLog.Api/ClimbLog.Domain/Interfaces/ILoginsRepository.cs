using ClimbLog.Domain.Models.Entities;
using ClimbLog.Domain.Models.RepoResponses;

namespace ClimbLog.Domain.Interfaces;

public interface ILoginsRepository
{
    Task AddLogin(Login login);
    Task DeleteLoginByUserName(string username);
    Task<bool> DoesThisUserAlreadyExist(string username, string? email);
    Task<Login?> GetLoginByEmail(string email);
    Task<Login> GetLoginById(int id);
    Task<Login?> GetLoginBySocialIdentifier(string socialIdentifier);
    Task<Login?> GetLoginByUsername(string username);
    Task<List<SearchLoginsByStringResponse>> SearchLoginsByString(string searchString, int gymId);
    Task UpdateAccountDetails(int loginId, string friendlyName, string? bioText);
    Task UpdateProfilePictureUrl(int loginId, string profilePictureUrl);
    Task UpdatePushNotificationToken(int loginId, string pushNotificationToken);
}