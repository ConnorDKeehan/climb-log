using AutoMapper;
using ClimbLog.Application.Features.ClimbLog.Commands.LogClimb;

namespace ClimbLog.Application.Features.ClimbLog;
public class ClimbLogMappingProfile : Profile
{
    public ClimbLogMappingProfile()
    {
        CreateMap<LogClimbCommand, Domain.Models.Entities.ClimbLog>();
    }
}
