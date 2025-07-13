using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Responses;
public class UserInfoResponse
{
    public int Id { get; set; }
    public required string DisplayName { get; set; }
    public int? AttemptCount { get; set; }
    public string? DifficultyVote { get; set; }
    public string? Notes { get; set; }
}
