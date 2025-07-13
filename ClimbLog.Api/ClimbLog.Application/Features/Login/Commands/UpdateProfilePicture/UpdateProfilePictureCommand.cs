using MediatR;
using Microsoft.AspNetCore.Http;

namespace ClimbLog.Application.Features.Login.Commands.UpdateProfilePicture;
public class UpdateProfilePictureCommand : IRequest<Unit>
{
    public int LoginId { get; set; }
    public required IFormFile profilePicture { get; set; }
}
