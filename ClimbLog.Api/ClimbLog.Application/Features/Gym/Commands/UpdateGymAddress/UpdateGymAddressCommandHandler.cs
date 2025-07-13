using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Gym.Commands.UpdateGymAddress;

public class UpdateGymAddressCommandHandler(IGymsRepository gymsRepository) : IRequestHandler<UpdateGymAddressCommand, Unit>
{
    public async Task<Unit> Handle(UpdateGymAddressCommand command, CancellationToken cancellationToken = default)
    {
        var gym = await gymsRepository.GetGymByName(command.GymName);

        await gymsRepository.UpdateGymAddress(gym.Id, command.GymAddress);

        return Unit.Value;
    }
}
