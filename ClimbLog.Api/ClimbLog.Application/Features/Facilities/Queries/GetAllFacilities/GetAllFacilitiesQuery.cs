using ClimbLog.Domain.Models.Entities;
using MediatR;

namespace ClimbLog.Application.Features.Facilities.Queries.GetAllFacilities;
public class GetAllFacilitiesQuery : IRequest<List<Facility>>
{
}
