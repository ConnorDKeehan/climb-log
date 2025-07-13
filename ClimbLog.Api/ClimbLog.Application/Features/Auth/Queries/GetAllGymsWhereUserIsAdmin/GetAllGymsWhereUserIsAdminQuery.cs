using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Auth.Queries.GetAllGymsWhereUserIsAdmin;
public class GetAllGymsWhereUserIsAdminQuery : IRequest<List<string>>
{
    public int LoginId { get; set; }
}
