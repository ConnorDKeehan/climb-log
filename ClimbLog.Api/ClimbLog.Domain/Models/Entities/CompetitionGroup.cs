namespace ClimbLog.Domain.Models.Entities;
public class CompetitionGroup
{
    public int Id { get; set; }
    public int CompetitionId { get; set; }
    public int CompetitionGroupRuleId { get; set; }
    public required string Name { get; set; }
    //NavigationalProperties
    public List<CompetitionGroupLogin>? CompetitionGroupLogins { get; set; }
    public CompetitionGroupRule? CompetitionGroupRule { get; set; }
}
