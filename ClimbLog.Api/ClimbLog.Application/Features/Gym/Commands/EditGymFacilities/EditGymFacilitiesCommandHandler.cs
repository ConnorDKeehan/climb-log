using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Gym.Commands.EditGymFacilities;
public class EditGymFacilitiesCommandHandler(IGymFacilitiesRepository gymFacilitiesRepository, IGymsRepository gymsRepository) 
    : IRequestHandler<EditGymFacilitiesCommand, Unit>
{
    public async Task<Unit> Handle(EditGymFacilitiesCommand command, CancellationToken cancellationToken = default)
    {
        var gym = await gymsRepository.GetGymByName(command.GymName);

        await gymFacilitiesRepository.ReplaceGymFacilities(gym.Id, command.FacilityIds);

        return Unit.Value;
    }
}
