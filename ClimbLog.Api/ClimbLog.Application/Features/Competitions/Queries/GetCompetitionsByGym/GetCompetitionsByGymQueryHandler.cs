using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;

namespace ClimbLog.Application.Features.Competitions.Queries.GetCompetitionsByGym;
public class GetCompetitionsByGymQueryHandler(
    ICompetitionsRepository competitionsRepository, 
    IGymsRepository gymsRepository,
    ICompetitionGroupsRepository competitionGroupsRepository) 
    : IRequestHandler<GetCompetitionsByGymQuery, List<GetCompetitionByGymQueryReponse>>
{
    public async Task<List<GetCompetitionByGymQueryReponse>> Handle(GetCompetitionsByGymQuery query, CancellationToken cancellationToken)
    {
        var gym = await gymsRepository.GetGymByName(query.GymName);
        var competitions = await competitionsRepository.GetCompetitionsByGymId(gym.Id);

        var result = new List<GetCompetitionByGymQueryReponse>();

        foreach(var competition in competitions)
        {
            var competitionResponse = new GetCompetitionByGymQueryReponse 
            { 
                CompetitionId = competition.Id,
                CompetitionName = competition.Name,
                StartDate = competition.StartDate,
                EndDate = competition.EndDate,
                Active = competition.Active,
                SingleGroupId = competition.CompetitionGroups?.Count == 1 ? competition.CompetitionGroups[0].Id : null,
                IsUserEntered = false
            };

            var usersCompetitionGroup = await competitionGroupsRepository.GetCompetitionGroupsByCompIdAndLoginId(competition.Id, query.LoginId);

            if(usersCompetitionGroup != null)
            {
                competitionResponse.CompetitionGroupId = usersCompetitionGroup.Id;
                competitionResponse.CompetitionName = competition.Name + " - " + usersCompetitionGroup.Name;
                competitionResponse.IsUserEntered = true;
            }

            result.Add(competitionResponse);
        }
        

        return result;
    }
}
