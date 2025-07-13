using Amazon.Runtime.Internal;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Queries.CheckUserIsGymAdmin;

public class CheckUserIsGymAdminQuery : IRequest<bool>
{
    public required List<string> GymName { get; set; }
    public int LoginId { get; set; }
}
