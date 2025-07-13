using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Commands.Register
{
    public class RegisterCommand : IRequest<Unit>
    {
        public string Username { get; set; }
        public string? Email { get; set; }
        public string Password { get; set; }
        public string? FriendlyName { get; set; }
        public string? PushNotificationToken { get; set; }
    }
}
