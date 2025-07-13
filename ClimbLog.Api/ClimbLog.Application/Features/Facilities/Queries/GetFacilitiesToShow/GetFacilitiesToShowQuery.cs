using ClimbLog.Domain.Models.Entities;
using MediatR;

namespace ClimbLog.Application.Features.Facilities.Queries.GetFacilitiesToShow;
public class GetFacilitiesToShowQuery : IRequest<List<Facility>>
{
    public required string GymName { get; set; }
}
