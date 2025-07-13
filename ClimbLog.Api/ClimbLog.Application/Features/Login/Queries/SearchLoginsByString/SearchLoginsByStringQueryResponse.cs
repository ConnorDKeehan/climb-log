using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Logins.Queries.SearchLoginsByString;

public class SearchLoginsByStringQueryResponse
{
    public int LoginId { get; set; }
    public required string DisplayName { get; set; }
    public bool IsGymAdmin { get; set; }
    public string? ProfileImageUrl { get; set; }
}
