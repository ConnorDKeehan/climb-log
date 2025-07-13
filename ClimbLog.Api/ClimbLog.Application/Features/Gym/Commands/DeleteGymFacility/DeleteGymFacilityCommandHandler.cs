using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Gym.Commands.DeleteGymFacility;

public class DeleteGymFacilityCommandHandler(
    IFacilitiesRepository facilitiesRepository,
    IGymsRepository gymsRepository,
    IGymFacilitiesRepository gymFacilitiesRepository
    ) : IRequestHandler<DeleteGymFacilityCommand, Unit>
{
    public async Task<Unit> Handle(DeleteGymFacilityCommand command, CancellationToken cancellationToken = default)
    {
        var facility = await facilitiesRepository.GetFacilityByName(command.FacilityName);
        var gym = await gymsRepository.GetGymByName(command.GymName);

        await gymFacilitiesRepository.DeleteGymFacility(gym.Id, facility.Id);

        return Unit.Value;
    }
}
