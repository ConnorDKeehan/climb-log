using AutoMapper;
using ClimbLog.Application.Utilities;
using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using TimeZoneConverter;

namespace ClimbLog.Application.Features.ClimbLog.Commands.LogClimb;

public class LogClimbCommandHandler(
        IClimbLogsRepository climbLogsRepository, 
        IMapper mapper, 
        IStoredProceduresRepository storedProceduresRepository,
        IGymsRepository gymsRepository
    ) : IRequestHandler<LogClimbCommand, Unit>
{
    public async Task<Unit> Handle(LogClimbCommand command, CancellationToken cancellationToken = default)
    {
        var competitionGroupId = await storedProceduresRepository.GetCompetitionGroupByRouteIdAndLoginId(command.RouteId, command.LoginId);

        var gym = await gymsRepository.GetGymByRouteId(command.RouteId);

        DateTime localDateTime = DateTimeHelper.GetLocalDateFromTimeZone(gym.TimeZoneIdentifier);

        var entity = mapper.Map<Domain.Models.Entities.ClimbLog>(command);
        entity.CompetitionGroupId = competitionGroupId;
        entity.DateAddedUTC = DateTime.UtcNow;
        entity.DateAdded = localDateTime;
        entity.Date = DateOnly.FromDateTime(localDateTime);

        await climbLogsRepository.LogClimb(entity);

        return Unit.Value;
    }
}
