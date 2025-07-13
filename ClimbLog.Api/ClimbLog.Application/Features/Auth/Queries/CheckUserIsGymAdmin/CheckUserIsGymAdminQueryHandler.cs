using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Auth.Queries.CheckUserIsGymAdmin;

public class CheckUserIsGymAdminQueryHandler(IGymsRepository gymsRepository, IGymAdminsRepository gymAdminsRepository) 
    : IRequestHandler<CheckUserIsGymAdminQuery, bool>
{
    public async Task<bool> Handle(CheckUserIsGymAdminQuery query, CancellationToken cancellationToken = default)
    {
        var gyms = await gymsRepository.GetGymsByNames(query.GymName);

        var gymIds = gyms.Select(x => x.Id).ToList();

        var result = await gymAdminsRepository.IsUserAdmin(gymIds, query.LoginId);

        return result;
    }
}
