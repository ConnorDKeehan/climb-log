using ClimbLog.Application.Interfaces;
using ClimbLog.Domain.Interfaces;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Application.Features.Login.Commands.UpdateProfilePicture;
public class UpdateProfilePictureCommandHandler(IS3Service s3Service, ILoginsRepository loginsRepository) 
    : IRequestHandler<UpdateProfilePictureCommand, Unit>
{
    public async Task<Unit> Handle(UpdateProfilePictureCommand command, CancellationToken cancellationToken)
    {
        var extension = Path.GetExtension(command.profilePicture.FileName);
        var fileName = $"{command.LoginId}{extension}";
        var fileUrl = await s3Service.UploadFileAsync("profile_pictures/" + fileName, command.profilePicture);

        await loginsRepository.UpdateProfilePictureUrl(command.LoginId, fileUrl);

        return Unit.Value;
    }
}
