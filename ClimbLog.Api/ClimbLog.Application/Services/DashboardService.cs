using AutoMapper;
using ClimbLog.Application.Interfaces;
using ClimbLog.Api.Responses;
using ClimbLog.Domain.Interfaces;

namespace ClimbLog.Api.Services
{
    public class DashboardService(IStoredProceduresRepository storedProceduresRepository, IMapper mapper) : IDashboardService
    {
        public async Task<GetPersonalStatsByGymResponse> GetPersonalStatsByGym(string gymName, int loginId)
        {
            var pointsAndAscents = await storedProceduresRepository.GetPointsAndAscents(gymName, loginId);
            var allTimeGradesAscents = await storedProceduresRepository.GetAscentsGroupByName(gymName, loginId, false);
            var lastWeekGradesAscents = await storedProceduresRepository.GetAscentsGroupByName(gymName, loginId, true);

            var result = new GetPersonalStatsByGymResponse()
            {
                TotalPoints = pointsAndAscents.TotalPoints,
                TotalAscents = pointsAndAscents.TotalAscents,
                TotalGymRanking = pointsAndAscents.TotalGymRanking,
                TotalGradeAscendedCount = mapper.Map<List<GradeAscendedCount>>(allTimeGradesAscents),
                LastWeekPoints = pointsAndAscents.LastWeekPoints,
                LastWeekAscents = pointsAndAscents.LastWeekAscents,
                LastWeekGymRanking = pointsAndAscents.LastWeekGymRanking,
                LastWeekAscendedCount = mapper.Map<List<GradeAscendedCount>>(lastWeekGradesAscents)
            };

            return result;
        }
    }
}
