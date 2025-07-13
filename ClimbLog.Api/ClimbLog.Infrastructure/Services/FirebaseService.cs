using ClimbLog.Domain.Interfaces;
using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using Microsoft.Extensions.Logging;
using System.Reflection;

namespace ClimbLog.Infrastructure.Services;

public class FirebaseService : IFirebaseService
{
    private readonly ILoggingRespository loggingRespository;
    private readonly ILoginsRepository loginsRepository;
    public FirebaseService(ILoggingRespository loggingRespository, ILoginsRepository loginsRepository)
    {
        this.loggingRespository = loggingRespository;
        this.loginsRepository = loginsRepository;
    }

    public async Task SendNotificationsAsyncByLoginId(int loginId, string title, string body, Dictionary<string, string>? data = null)
    {
        var login = await loginsRepository.GetLoginById(loginId);

        var token = login.PushNotificationToken;

        if(token != null) { await SendNotificationsAsync([token], title, body, data); }
    }

    public async Task SendNotificationsAsync(List<string> tokens, string title, string body, Dictionary<string, string>? data = null)
    {
        // Create the message payload
        List<Message> messages = new();

        foreach (var token in tokens)
        {
            var message = new Message()
            {
                Token = token,
                Notification = new Notification()
                {
                    Title = title,
                    Body = body,
                    ImageUrl = "https://climblogapi.s3.ap-southeast-2.amazonaws.com/play_store_512.png"
                }
            };
            if (data != null)
            {
                message.Data = data;
            }

            messages.Add(message);
        }


        // Send the notification
        BatchResponse response = await FirebaseMessaging.DefaultInstance.SendEachAsync(messages);

        loggingRespository.Log<FirebaseService>(
            $"Successfuly sent {response.SuccessCount} notifications. {response.FailureCount} failed.", LogLevel.Information
        );
    }
}
