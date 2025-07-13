using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Commands.DeleteLogin;
public class DeleteLoginCommand : IRequest<Unit>
{
    public required string Username { get; set; }
    public required string Password { get; set; }
}
