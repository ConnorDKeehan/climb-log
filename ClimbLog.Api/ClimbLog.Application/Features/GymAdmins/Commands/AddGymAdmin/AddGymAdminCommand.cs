using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.GymAdmins.Commands.AddGymAdmin;
public class AddGymAdminCommand : IRequest<Unit>
{
    public int LoginId { get; set; }
    public required string GymName { get; set; }
}
