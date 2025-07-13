using ClimbLog.Domain.Interfaces;
using MediatR;
using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Application.Features.GymAdmins.Commands.AddGymAdmin;
public class AddGymAdminCommandHandler(
    IGymAdminsRepository gymAdminsRepository,
    IGymsRepository gymsRepository
    ) : IRequestHandler<AddGymAdminCommand, Unit>
{
    public async Task<Unit> Handle(AddGymAdminCommand command, CancellationToken cancellationToken)
    {
        var gym = await gymsRepository.GetGymByName(command.GymName);

        var isUserGymAdmin = await gymAdminsRepository.IsUserAdmin([gym.Id], command.LoginId);

        if (isUserGymAdmin)
            throw new ArgumentException("User is already admin at this gym");

        await gymAdminsRepository.AddGymAdmin(new GymAdmin {GymId = gym.Id, LoginId = command.LoginId});

        return Unit.Value;
    }
}
