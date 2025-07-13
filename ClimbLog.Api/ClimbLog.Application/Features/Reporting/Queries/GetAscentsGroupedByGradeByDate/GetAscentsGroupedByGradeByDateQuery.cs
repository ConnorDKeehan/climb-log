using ClimbLog.Domain.Models.SpResponses;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Reporting.Queries.GetAscentsGroupedByGradeByDate;
public class GetAscentsGroupedByGradeByDateQuery : IRequest<List<GetAscentsGroupedByGradeByDateSpResponse>>
{
    public required string GymName {  get; set; }
    public int LoginId { get; set; }
}
