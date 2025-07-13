
using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.SpResponses;
using ClimbLog.Domain.Models.Views;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Reporting.Queries.GetMainDataView;
public class GetMainDataViewQueryHandler(IMainDataRepository mainDataRepository)
    : IRequestHandler<GetMainDataViewQuery, List<vwMainData>>
{
    public async Task<List<vwMainData>> Handle(GetMainDataViewQuery query, CancellationToken cancellationToken)
    {
        var result = await mainDataRepository.GetMainDataByGymNameAndLoginId(query.GymName, query.LoginId);

        return result;
    }
}
