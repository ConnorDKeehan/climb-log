using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Login.Queries.GetAccountDetails;

public class GetAccountDetailsQuery : IRequest<GetAccountDetailsQueryResponse>
{ 
    public int LoginId { get; set; }
}
