using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Login.Commands.EditAccountDetails;
public class EditAccountDetailsCommand : IRequest<Unit>
{
    public int LoginId { get; set; }
    public required string FriendlyName { get; set; }
    public string? BioText { get; set; }
}
