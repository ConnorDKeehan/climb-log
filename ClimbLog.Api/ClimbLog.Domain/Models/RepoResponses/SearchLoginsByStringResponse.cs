using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.RepoResponses;
public class SearchLoginsByStringResponse
{
    public int LoginId { get; set; }
    public required string Username { get; set; }
    public string? FriendlyName { get; set; }
    public bool IsGymAdmin { get; set; }
}
