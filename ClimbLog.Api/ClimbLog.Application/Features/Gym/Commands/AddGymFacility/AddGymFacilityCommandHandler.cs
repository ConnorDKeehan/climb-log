using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Gym.Commands.AddGymFacility;

public class AddGymFacilityCommandHandler(
    IFacilitiesRepository facilitiesRepository, 
    IGymsRepository gymsRepository, 
    IGymFacilitiesRepository gymFacilitiesRepository
    ) : IRequestHandler<AddGymFacilityCommand, Unit>
{
    public async Task<Unit> Handle(AddGymFacilityCommand command, CancellationToken cancellationToken = default)
    {
        var facility = await facilitiesRepository.GetFacilityByName(command.FacilityName);
        var gym = await gymsRepository.GetGymByName(command.GymName);

        await gymFacilitiesRepository.AddGymFacility(gym.Id, facility.Id);

        return Unit.Value;
    }
}
