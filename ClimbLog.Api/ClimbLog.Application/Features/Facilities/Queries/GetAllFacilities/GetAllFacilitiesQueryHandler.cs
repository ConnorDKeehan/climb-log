using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Facilities.Queries.GetAllFacilities;

public class GetAllFacilitiesQueryHandler(IFacilitiesRepository facilitiesRepository) : IRequestHandler<GetAllFacilitiesQuery, List<Facility>>
{
    public async Task<List<Facility>> Handle(GetAllFacilitiesQuery query, CancellationToken cancellationToken = default)
    {
        var result = await facilitiesRepository.GetAllFacilities();

        return result;
    }
}
