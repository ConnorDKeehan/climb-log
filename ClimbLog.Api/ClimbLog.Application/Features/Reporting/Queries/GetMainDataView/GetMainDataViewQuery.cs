using ClimbLog.Domain.Models.SpResponses;
using ClimbLog.Domain.Models.Views;
using MediatR;

namespace ClimbLog.Application.Features.Reporting.Queries.GetMainDataView;
public class GetMainDataViewQuery : IRequest<List<vwMainData>>
{
    public required string GymName { get; set; }
    public int LoginId { get; set; }
}
