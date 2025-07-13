using MediatR;

namespace ClimbLog.Application.Features.ClimbLog.Queries.GetAllClimbLogs;

public class GetAllClimbLogsQuery : IRequest<List<Domain.Models.Entities.ClimbLog>>
{
    public int LoginId {  get; set; }
}
