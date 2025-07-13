using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Reporting.Queries.GetCurrentWeekPoints;
public class GetCurrentNumOfClimbsQuery : IRequest<List<GetCurrentNumOfClimbsResponse>>
{
    public required string GymName { get; set; }
}
