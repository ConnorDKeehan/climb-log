using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Login.Queries.GetAccountDetails;
public class GetAccountDetailsQueryResponse
{
    public string? Email { get; set; }
    public string? FriendlyName { get; set; }
    public required string UserName { get; set; }
    public string? ProfilePictureUrl { get; set; }
    public string? BioText { get; set; }
    public string? DateCreated { get; set; }
}
