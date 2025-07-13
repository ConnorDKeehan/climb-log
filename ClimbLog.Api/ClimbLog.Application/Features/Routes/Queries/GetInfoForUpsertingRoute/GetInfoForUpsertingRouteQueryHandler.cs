using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;

namespace ClimbLog.Application.Features.Routes.Queries.GetInfoForUpsertingRoute;

public class GetInfoForUpsertingRouteQueryHandler(
    IGradesRepository gradesRepository,
    ISectorsRepository sectorsRepository,
    ICompetitionsRepository competitionsRepository,
    IRoutesRepository routesRepository,
    IGymsRepository gymsRepository) : IRequestHandler<GetInfoForUpsertingRouteQuery, GetInfoForUpsertingRouteQueryResponse>
{
    public async Task<GetInfoForUpsertingRouteQueryResponse> Handle(GetInfoForUpsertingRouteQuery query, CancellationToken cancellationToken)
    {
        var gym = await gymsRepository.GetGymByName(query.GymName);

        var grades = await gradesRepository.GetGradesByGradeSystemId(gym.GradeSystemId);
        List<Grade> standardGrades = gym.StandardGradeSystemId != null 
            ? await gradesRepository.GetGradesByGradeSystemId(gym.StandardGradeSystemId.Value) : [];


        var sectors = await sectorsRepository.GetSectorsByGymId(gym.Id);
        var competitions = await competitionsRepository.GetCompetitionsByGymId(gym.Id);

        var result = new GetInfoForUpsertingRouteQueryResponse
        {
            Grades = grades,
            StandardGrades = standardGrades,
            Competitions = competitions,
            Sectors = sectors
        };

        //No need to get route details if there is no route.
        //This will be the case where frontend is adding a new route rather than editing one.
        if (query.ExistingRouteId == null)
        {
            return result;
        }


        var route = await routesRepository.GetDetailedRouteById(query.ExistingRouteId.Value);

        result.CurrentGrade = route.Grade;
        result.CurrentStandardGrade = route.StandardGrade;
        result.CurrentSector = route.Sector;
        result.CurrentCompetition = route.Competition;
        result.CurrentPointValue = route.Points;

        return result;
    }
}
