using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Login.Commands.EditAccountDetails;
public class EditAccountDetailsCommandHandler(ILoginsRepository loginsRepository) : IRequestHandler<EditAccountDetailsCommand, Unit>
{
    public async Task<Unit> Handle(EditAccountDetailsCommand command, CancellationToken cancellationToken)
    {
        await loginsRepository.UpdateAccountDetails(command.LoginId, command.FriendlyName, command.BioText);

        return Unit.Value;
    }
}
