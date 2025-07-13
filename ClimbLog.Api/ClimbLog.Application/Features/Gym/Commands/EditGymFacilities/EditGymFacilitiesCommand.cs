using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Gym.Commands.EditGymFacilities;
public class EditGymFacilitiesCommand : IRequest<Unit>
{
    public required string GymName { get; set; }
    public required List<int> FacilityIds { get; set; }
}
