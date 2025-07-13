using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.ClimbLog.Queries.GetAllClimbLogs;

public class GetAllClimbLogsQueryHandler(IClimbLogsRepository climbLogsRepository) 
    : IRequestHandler<GetAllClimbLogsQuery, List<Domain.Models.Entities.ClimbLog>>
{
    public async Task<List<Domain.Models.Entities.ClimbLog>> Handle(GetAllClimbLogsQuery query, CancellationToken cancellationToken = default)
    {
        var result = await climbLogsRepository.GetAllClimbLogsByLoginId(query.LoginId);

        return result;
    }
}
