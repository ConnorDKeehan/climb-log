using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Grades.Queries.GetGymGradesByGymName;

public class GetGymGradesByGymNameQueryHandler(IGymsRepository gymsRepository, IGradesRepository gradesRepository)
    : IRequestHandler<GetGymGradesByGymNameQuery, GetGymGradesByGymNameResponse>
{
    public async Task<GetGymGradesByGymNameResponse> Handle(GetGymGradesByGymNameQuery query, CancellationToken cancellationToken = default)
    {
        var gym = await gymsRepository.GetGymByName(query.GymName);

        var gymGrades = await gradesRepository.GetGradesByGradeSystemId(gym.GradeSystemId);
        var standardGrades = new List<Grade>();

        if(gym.StandardGradeSystemId != null)
            standardGrades = await gradesRepository.GetGradesByGradeSystemId(gym.StandardGradeSystemId.Value);

        return new GetGymGradesByGymNameResponse {Grades = gymGrades, StandardGrades = standardGrades};
    }
}
