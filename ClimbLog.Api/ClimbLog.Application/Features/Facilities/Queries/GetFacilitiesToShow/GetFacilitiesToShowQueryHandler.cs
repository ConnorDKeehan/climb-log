using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Facilities.Queries.GetFacilitiesToShow;
public class GetFacilitiesToShowQueryHandler(
    IFacilitiesRepository facilitiesRepository, 
    IGymFacilitiesRepository gymFacilitiesRepository,
    IGymsRepository gymsRepository
    ) : IRequestHandler<GetFacilitiesToShowQuery, List<Facility>>
{
    public async Task<List<Facility>> Handle(GetFacilitiesToShowQuery query, CancellationToken cancellationToken = default)
    {
        var allFacilities = await facilitiesRepository.GetAllFacilities();
        var gym = await gymsRepository.GetGymByName(query.GymName);

        var existingFacilityIds = await gymFacilitiesRepository.GetGymFacilityIdsByGymId(gym.Id);

        var result = allFacilities.Where(x => !existingFacilityIds.Contains(x.Id)).ToList();

        return result;
    }
}
