using ClimbLog.Application.Features.Grades.Queries.GetGymGradesByGymName;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Grades.Queries.GetGymGradeNamesByGymName;

public class GetGymGradeNamesByGymNameQueryHandler(IMediator mediator)
    : IRequestHandler<GetGymGradeNamesByGymNameQuery, GetGymGradeNamesByGymNameQueryResponse>
{
    public async Task<GetGymGradeNamesByGymNameQueryResponse> Handle(GetGymGradeNamesByGymNameQuery query, CancellationToken cancellationToken = default)
    {

        var grades = await mediator.Send(new GetGymGradesByGymNameQuery { GymName = query.GymName });

        List<string> gymGrades = grades.Grades.Select(x => x.GradeName).ToList();
        List<string> standardGrades = grades.StandardGrades.Select(x => x.GradeName).ToList();

        return new GetGymGradeNamesByGymNameQueryResponse { Grades = gymGrades, StandardGrades = standardGrades};
    }
}
