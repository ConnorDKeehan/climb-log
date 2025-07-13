using ClimbLog.Application.Interfaces;
using ClimbLog.Domain.Interfaces;
using Google.Apis.Auth;
using MediatR;
using Microsoft.IdentityModel.Protocols;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using System.Security.Claims;
using ClimbLog.Domain.Models.Entities;
using Microsoft.Extensions.Configuration;
using Google.Apis.Util;

namespace ClimbLog.Application.Features.Auth.Commands.LoginWithSocial;

public class LoginWithSocialCommandHandler : IRequestHandler<LoginWithSocialCommand, string>
{
    private readonly string GoogleClientId;
    private readonly string GoogleClientSecret;
    private readonly ILoginsRepository loginsRepository;
    private readonly IAuthService authService;

    private const string AppleClientId = "com.connor.climasys";

    public LoginWithSocialCommandHandler(
        ILoginsRepository loginsRepository,
        IConfiguration config,
        IAuthService authService
)
    {
        this.loginsRepository = loginsRepository;
        this.authService = authService;
        GoogleClientId = config["Google:ClientId"]!;
        GoogleClientSecret = config["Google:ClientSecret"]!;

        if (GoogleClientId == null || GoogleClientSecret == null) {
            throw new ArgumentNullException("Google client secret or client Id mustn't be null");
        }
    }

    public async Task<string> Handle(LoginWithSocialCommand command, CancellationToken cancellationToken)
    {
        // We'll parse out the user's email/name from each provider
        string? userEmail;
        string userName;
        string? socialLoginIdentifier = null;
        Domain.Models.Entities.Login? existingUser = null;

        switch (command.Provider?.ToLower())
        {
            case "google":
                var googleIdToken = await ExchangeCodeForIdTokenAsync(command.IdToken);

                var googlePayload = await GoogleJsonWebSignature.ValidateAsync(
                    googleIdToken,
                    new GoogleJsonWebSignature.ValidationSettings
                    {
                        Audience = new[] { GoogleClientId },
                    }
                );

                userEmail = googlePayload.Email;
                socialLoginIdentifier = googlePayload.Email;
                userName = googlePayload.Name ?? googlePayload.GivenName ?? "GoogleUser";
                existingUser = await loginsRepository.GetLoginByEmail(userEmail);
                break;

            case "apple":
                var appleClaimsPrincipal = await ValidateAppleIdTokenAsync(command.IdToken);

                userEmail = appleClaimsPrincipal.FindFirstValue(ClaimTypes.Email);
                socialLoginIdentifier = appleClaimsPrincipal.FindFirstValue(ClaimTypes.NameIdentifier);
                userName = command.FriendlyName ?? "Apple User";

                existingUser = await loginsRepository.GetLoginBySocialIdentifier(socialLoginIdentifier!);
                break;

            default:
                throw new System.Exception("Unsupported social provider");
        }

        if (existingUser == null)
        {
            // Create user if not found
            existingUser = new Domain.Models.Entities.Login
            {
                Username = userEmail ?? Guid.NewGuid().ToString(),
                Email = userEmail,
                Password = "placeholder", // not used for social logins
                FriendlyName = userName,
                PushNotificationToken = command.PushNotificationToken,
                SocialLoginIdentifier = socialLoginIdentifier,
                DateCreatedUtc = DateTime.UtcNow,
            };
            await loginsRepository.AddLogin(existingUser);
        }

        var jwtToken = authService.GenerateJwtToken(existingUser);
        return jwtToken;
    }

    private async Task<string> ExchangeCodeForIdTokenAsync(string authCode)
    {
        using var client = new HttpClient();

        var content = new FormUrlEncodedContent(new[]
        {
            new KeyValuePair<string, string>("code", authCode),
            new KeyValuePair<string, string>("client_id", GoogleClientId),
            new KeyValuePair<string, string>("client_secret", GoogleClientSecret),
            // If you have a real redirect URI, specify it. Otherwise, an empty string sometimes works:
            new KeyValuePair<string, string>("redirect_uri", ""),
            new KeyValuePair<string, string>("grant_type", "authorization_code")
        });

        var response = await client.PostAsync("https://oauth2.googleapis.com/token", content);
        response.EnsureSuccessStatusCode();

        var json = await response.Content.ReadAsStringAsync();
        using var doc = JsonDocument.Parse(json);

        if (!doc.RootElement.TryGetProperty("id_token", out var idTokenElement))
        {
            throw new System.Exception("id_token not found in Google token exchange response.");
        }
        return idTokenElement.GetString()!;
    }

    private static async Task<ClaimsPrincipal> ValidateAppleIdTokenAsync(string appleIdToken)
    {
        var handler = new JwtSecurityTokenHandler();

        // Fetch Apple's OpenID Connect metadata (includes public keys)
        var configManager = new ConfigurationManager<OpenIdConnectConfiguration>(
            "https://appleid.apple.com/.well-known/openid-configuration",
            new OpenIdConnectConfigurationRetriever()
        );
        var appleOpenIdConfig = await configManager.GetConfigurationAsync();

        var validationParameters = new TokenValidationParameters
        {
            ValidIssuer = "https://appleid.apple.com",
            IssuerSigningKeys = appleOpenIdConfig.SigningKeys,

            // If you have a service ID or "client_id" for Apple,
            // you can check that the token's "aud" matches your own AppleClientId
            ValidAudience = AppleClientId, // e.g. "com.example.apple.clientid"
            ValidateAudience = true,       // set to true if you want to enforce audience checking
        };

        var claimsPrincipal = handler.ValidateToken(appleIdToken, validationParameters, out _);
        return claimsPrincipal;
    }
}
