using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Gym.Commands.UpsertDefaultGymOpeningHours;

public class UpsertDefaultGymOpeningHoursCommandHandler(IGymsRepository gymsRepository, IGymDefaultOpeningHoursRepository gymDefaultOpeningHoursRepositorty) 
    : IRequestHandler<UpsertDefaultGymOpeningHoursCommand, Unit>
{
    public async Task<Unit> Handle(UpsertDefaultGymOpeningHoursCommand command, CancellationToken cancellationToken = default)
    {
        var gym = await gymsRepository.GetGymByName(command.GymName);

        foreach (var openingHour in command.OpeningHours)
        {
            await gymDefaultOpeningHoursRepositorty.UpsertGymDefaultOpeningHour(gym.Id, openingHour.WeekDay, openingHour.StartTime, openingHour.EndTime);
        }

        return Unit.Value;
    }
}
