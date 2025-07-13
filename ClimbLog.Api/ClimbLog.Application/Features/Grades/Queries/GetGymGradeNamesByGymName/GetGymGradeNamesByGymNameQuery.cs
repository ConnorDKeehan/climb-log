using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Grades.Queries.GetGymGradeNamesByGymName;

public class GetGymGradeNamesByGymNameQuery : IRequest<GetGymGradeNamesByGymNameQueryResponse>
{
    public string GymName { get; set; }
}
