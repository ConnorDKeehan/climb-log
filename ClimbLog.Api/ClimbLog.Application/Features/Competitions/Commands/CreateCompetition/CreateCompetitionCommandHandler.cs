using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using MediatR;

namespace ClimbLog.Application.Features.Competitions.Commands.CreateCompetition;
public class CreateCompetitionCommandHandler(
        IGymsRepository gymsRepository,
        ICompetitionGroupRulesRepository competitionGroupRulesRepository,
        ICompetitionsRepository competitionsRepository
    ) : IRequestHandler<CreateCompetitionCommand, Unit>
{
    public async Task<Unit> Handle(CreateCompetitionCommand command, CancellationToken cancellationToken = default)
    {
        Competition competition = new Competition
        {
            Name = command.Request.CompetitionName,
            StartDate = command.Request.StartDate.HasValue ? DateOnly.FromDateTime(command.Request.StartDate.Value) : null,
            EndDate = command.Request.EndDate.HasValue ? DateOnly.FromDateTime(command.Request.EndDate.Value) : null,
            GymCompetitions = new(),
            CompetitionGroups = new()
        };

        var gyms = await gymsRepository.GetGymsByNames(command.Request.GymNames);

        if (gyms.Count == 0)
            throw new ArgumentException("No valid gyms were provided in request");

        foreach( var gym in gyms)
        {
            var gymCompetition = new GymCompetition { GymId = gym.Id};
            competition.GymCompetitions.Add(gymCompetition);
        }

        foreach(var competitionGroupRequest in command.Request.CompetitionGroupsRequest)
        {
            var competitionGroupRule = await competitionGroupRulesRepository.AddOrGetCompetitionGroupRule(competitionGroupRequest.NumberOfClimbsIncluded);
            var competitionGroup = new CompetitionGroup { CompetitionGroupRuleId = competitionGroupRule.Id, Name = competitionGroupRequest.Name };
            competition.CompetitionGroups.Add(competitionGroup);
        }

        await competitionsRepository.AddCompetition(competition);

        return Unit.Value;
    }
}
