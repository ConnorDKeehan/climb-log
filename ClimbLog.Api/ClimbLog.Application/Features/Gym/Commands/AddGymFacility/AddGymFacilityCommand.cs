using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Gym.Commands.AddGymFacility;

public class AddGymFacilityCommand : IRequest<Unit>
{
    public required string GymName {  get; set; }
    public required string FacilityName { get; set; }
}
