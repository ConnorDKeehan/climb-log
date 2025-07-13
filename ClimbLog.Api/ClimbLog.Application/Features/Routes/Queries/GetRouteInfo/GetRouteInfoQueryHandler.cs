using ClimbLog.Application.Responses;
using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Routes.Queries.GetRouteInfo;
public class GetRouteInfoQueryHandler(
    IRoutesRepository routesRepository, 
    IClimbLogsRepository climbLogsRepository,
    IDifficultiesForGradeRepository difficultiesForGradeRepository,
    IGradesRepository gradesRepository,
    ICompetitionsRepository competitionsRepository
) : IRequestHandler<GetRouteInfoQuery, GetRouteInfoQueryResponse>
{
    public async Task<GetRouteInfoQueryResponse> Handle(GetRouteInfoQuery query, CancellationToken cancellationToken)
    {
        var route = await routesRepository.GetRouteById(query.Id);

        var competition = route.CompetitionId != null ? 
            await competitionsRepository.GetActiveCompetitionById(route.CompetitionId.Value) : null;

        var grade = await gradesRepository.GetGradeById(route.GradeId);

        var standardGrade = route.StandardGradeId != null ? 
            await gradesRepository.GetGradeById(route.StandardGradeId.Value) : null;

        var climbLogs = await climbLogsRepository.GetDetailedClimbLogsByRouteId(query.Id);

        if (climbLogs.Count == 0)
        {
            return new GetRouteInfoQueryResponse
            {
                Id = route.Id,
                DateCreated = DateTime.SpecifyKind(route.DateAddedUTC, DateTimeKind.Utc).ToLocalTime(),
                Grade = grade,
                StandardGrade = standardGrade,
                Points = route.Points ?? standardGrade?.Points ?? grade.Points,
                Competition = competition,
                DifficultyVotes = [],
                AttemptCounts = [],
                UsersAscended = [],
                Notes = []
            };
        }

        var difficultyConsensus = await GetDifficultyConsensus(climbLogs);
        var averageAttemptCount = GetAverageAttemptCount(climbLogs);

        var difficultyVotes = climbLogs
            .Where(x => x.DifficultyForGrade != null)
            .GroupBy(x => x.DifficultyForGrade!.Name)
            .Select(g => new KeyValuePair<string,int>(g.Key, g.Count()))
            .ToList();

        var attemptCounts = climbLogs
            .Where(x => x.AttemptCount != null)
            .GroupBy(x => x.AttemptCount)
            .Select(g => new KeyValuePair<int, int>(g.Key!.Value, g.Count()))
            .ToList();

        var usersAscended = climbLogs
            .Select(x => new UserInfoResponse { 
                Id = x.LoginId,
                DisplayName = x.Login!.FriendlyName ?? x.Login.Username,
                AttemptCount = x.AttemptCount,
                DifficultyVote = x.DifficultyForGrade?.Name,
                Notes = x.Notes
            })
            .ToList();

        var notes = climbLogs
            .Where(x => x.Notes != null)
            .Select( x => x.Notes! )
            .ToList();

        return new GetRouteInfoQueryResponse { 
            Id = route.Id,
            DateCreated = DateTime.SpecifyKind(route.DateAddedUTC, DateTimeKind.Utc).ToLocalTime(),
            Grade = grade,
            StandardGrade = standardGrade,
            Points = route.Points ?? standardGrade?.Points ?? grade.Points,
            Competition = competition,
            DifficultyConsensus = difficultyConsensus,
            AverageAttemptCount = averageAttemptCount,
            DifficultyVotes = difficultyVotes ?? [],
            AttemptCounts = attemptCounts ?? [],
            UsersAscended = usersAscended ?? [],
            Notes = notes ?? []
        };
    }

    private int? GetAverageAttemptCount(List<Domain.Models.Entities.ClimbLog> climbLogs)
    {
        var attemptCounts = climbLogs
            .Where(x => x.AttemptCount.HasValue)
            .Select(x => x.AttemptCount!.Value)
            .ToList();

        if (attemptCounts.Count == 0)
        {
            return null;
        }

        var averageAttempts = attemptCounts.Average();
        var roundedAttempts = Convert.ToInt32(Math.Round(averageAttempts));

        return roundedAttempts;
    }

    private async Task<string?> GetDifficultyConsensus(List<Domain.Models.Entities.ClimbLog> climbLogs)
    {
        var difficultyNumbers = climbLogs
            .Where(x => x.DifficultyForGrade?.Number != null)
            .Select(x => x.DifficultyForGrade!.Number)
            .ToList();

        if (difficultyNumbers.Count == 0)
        {
            return null;
        }

        var averageDifficulty = difficultyNumbers.Average();
        var roundedDifficulty = Convert.ToInt32(Math.Round(averageDifficulty));

        var difficultyForGrade = await difficultiesForGradeRepository.GetDifficultyForGradeByNumber(roundedDifficulty);

        return difficultyForGrade.Name;
    }
}
