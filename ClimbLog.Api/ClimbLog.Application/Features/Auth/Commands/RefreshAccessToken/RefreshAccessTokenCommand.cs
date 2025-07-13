using ClimbLog.Application.Features.Auth.Responses;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Commands.RefreshAccessToken;

public class RefreshAccessTokenCommand : IRequest<AccessTokenResponse>
{
    public int LoginId { get; set; }
    public string? PushNotificationToken { get; set; }
}
