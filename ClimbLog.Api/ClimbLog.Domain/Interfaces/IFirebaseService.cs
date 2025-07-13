
namespace ClimbLog.Domain.Interfaces
{
    public interface IFirebaseService
    {
        Task SendNotificationsAsync(List<string> tokens, string title, string body, Dictionary<string, string>? data = null);
        Task SendNotificationsAsyncByLoginId(int loginId, string title, string body, Dictionary<string, string>? data = null);
    }
}