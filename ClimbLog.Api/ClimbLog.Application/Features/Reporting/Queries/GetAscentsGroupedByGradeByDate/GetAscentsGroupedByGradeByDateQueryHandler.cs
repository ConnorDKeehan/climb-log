using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.SpResponses;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Reporting.Queries.GetAscentsGroupedByGradeByDate;
public class GetAscentsGroupedByGradeByDateQueryHandler(IStoredProceduresRepository storedProceduresRepository)
    : IRequestHandler<GetAscentsGroupedByGradeByDateQuery, List<GetAscentsGroupedByGradeByDateSpResponse>>
{
    public async Task<List<GetAscentsGroupedByGradeByDateSpResponse>> Handle(GetAscentsGroupedByGradeByDateQuery query, CancellationToken cancellationToken)
    {
        var result = await storedProceduresRepository.GetAscentsGroupedByGradeByDate(query.GymName, query.LoginId);

        return result;
    }
}
