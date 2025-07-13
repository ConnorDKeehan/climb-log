using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Domain.Models.RepoResponses;

namespace ClimbLog.Infrastructure.Repositories;
public class LoginsRepository(ClimbLogContext dbContext) : ILoginsRepository
{
    public async Task<bool> DoesThisUserAlreadyExist(string username, string? email)
    {
        bool result = await dbContext.Logins.AnyAsync(u => u.Username == username || (u.Email == email && !string.IsNullOrEmpty(u.Email)));

        return result;
    }

    public async Task AddLogin(Login login)
    {
        dbContext.Logins.Add(login);
        await dbContext.SaveChangesAsync();
    }

    public async Task<Login?> GetLoginByUsername(string username)
    {
        var login = await dbContext.Logins.Where(u => u.Username == username && u.Deleted == false).SingleOrDefaultAsync();

        return login;
    }

    public async Task<Login?> GetLoginByEmail(string email)
    {
        var login = await dbContext.Logins.Where(u => u.Email == email && u.Deleted == false).SingleOrDefaultAsync();

        return login;
    }

    public async Task<Login?> GetLoginBySocialIdentifier(string socialIdentifier)
    {
        var login = await dbContext.Logins.Where(u => u.SocialLoginIdentifier == socialIdentifier && u.Deleted == false).SingleOrDefaultAsync();

        return login;
    }

    public async Task<Login> GetLoginById(int id)
    {
        var login = await dbContext.Logins.Where(x => x.Id == id && x.Deleted == false).SingleAsync();

        return login;
    }

    public async Task DeleteLoginByUserName(string username)
    {
        var login = await dbContext.Logins.Where(x => x.Username == username && x.Deleted == false).SingleAsync();

        login.Deleted = true;
        await dbContext.SaveChangesAsync();
    }

    public async Task<List<SearchLoginsByStringResponse>> SearchLoginsByString(string searchString, int gymId)
    {
        string likePattern = $"%{searchString}%";

        var result = await dbContext.Logins
            .Where(l => (EF.Functions.Like(l.Username, likePattern) ||
                        EF.Functions.Like(l.FriendlyName, likePattern) ||
                        EF.Functions.Like(l.Email, likePattern)) 
                        && l.Deleted == false)
            .Select(l => new SearchLoginsByStringResponse
            {
                LoginId = l.Id,
                Username = l.Username,
                FriendlyName = l.FriendlyName,
                IsGymAdmin = l.GymAdmins!.Any(ga => ga.GymId == gymId)
            })
            .ToListAsync();

        return result;
    }

    public async Task UpdatePushNotificationToken(int loginId, string pushNotificationToken)
    {
        var login = await dbContext.Logins.Where(x => x.Id == loginId).SingleAsync();

        login.PushNotificationToken = pushNotificationToken;

        await dbContext.SaveChangesAsync();
    }

    public async Task UpdateProfilePictureUrl(int loginId, string profilePictureUrl)
    {
        var login = await dbContext.FindAsync<Login>(loginId);

        if(login == null)
        {
            throw new KeyNotFoundException($"LoginId: {loginId} doesn't exist");
        }

        login.ProfilePictureUrl = profilePictureUrl;

        await dbContext.SaveChangesAsync();
    }

    public async Task UpdateAccountDetails(int loginId, string friendlyName, string? bioText)
    {
        var login = await dbContext.FindAsync<Login>(loginId);

        if(login == null)
        {
            ThrowLoginNotFoundError(loginId);
        }

        login!.FriendlyName = friendlyName;
        login!.BioText = bioText;

        await dbContext.SaveChangesAsync();
    }

    private void ThrowLoginNotFoundError(int loginId)
    {
        throw new KeyNotFoundException($"LoginId: {loginId} not found");
    }
}
