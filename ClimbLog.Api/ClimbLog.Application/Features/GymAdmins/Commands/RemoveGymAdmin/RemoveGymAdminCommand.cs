using MediatR;

namespace ClimbLog.Application.Features.GymAdmins.Commands.RemoveGymAdmin;
public class RemoveGymAdminCommand : IRequest<Unit>
{
    public int LoginId { get; set; }
    public required string GymName { get; set; }
}
