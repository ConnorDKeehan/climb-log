using AutoMapper;
using ClimbLog.Api.Responses;
using ClimbLog.Domain.Models.SpResponses;

namespace ClimbLog.Application.Features.Reporting;
public class ReportingProfile : Profile
{
    public ReportingProfile()
    {
        CreateMap<GetAscentsGroupedByGradeSpResponse, GradeAscendedCount>();
    }
}
