using ClimbLog.Application.Responses;
using ClimbLog.Domain.Models.Entities;

namespace ClimbLog.Application.Features.Routes.Queries.GetRouteInfo;
public class GetRouteInfoQueryResponse
{
    public int Id { get; set; }
    public DateTime DateCreated { get; set; }
    public string? DifficultyConsensus { get; set; }
    public int? AverageAttemptCount { get; set; }
    public required Grade Grade { get; set; }
    public Grade? StandardGrade { get; set; }
    public int Points { get; set; }
    public Competition? Competition { get; set; }
    public required List<KeyValuePair<string, int>> DifficultyVotes { get; set; } 
    public required List<KeyValuePair<int, int>> AttemptCounts { get; set; }
    public required List<UserInfoResponse> UsersAscended { get; set; }
    public required List<string> Notes { get; set; }
}