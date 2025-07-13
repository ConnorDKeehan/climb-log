using ClimbLog.Domain.Models.Entities;
using MediatR;

namespace ClimbLog.Application.Features.Grades.Queries.GetGymGradesByGymName;

public class GetGymGradesByGymNameQuery : IRequest<GetGymGradesByGymNameResponse>
{
    public required string GymName { get; set; }
}
