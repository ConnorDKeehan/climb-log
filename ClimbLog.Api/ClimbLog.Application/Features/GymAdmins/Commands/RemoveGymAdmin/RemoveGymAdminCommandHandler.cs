using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.GymAdmins.Commands.RemoveGymAdmin;
public class RemoveGymAdminCommandHandler(IGymAdminsRepository gymAdminsRepository, IGymsRepository gymsRepository) 
    : IRequestHandler<RemoveGymAdminCommand, Unit>
{
    public async Task<Unit> Handle(RemoveGymAdminCommand command, CancellationToken cancellationToken)
    {
        var gym = await gymsRepository.GetGymByName(command.GymName);

        await gymAdminsRepository.RemoveGymAdmin(gym.Id, command.LoginId);

        return Unit.Value;
    }
}
