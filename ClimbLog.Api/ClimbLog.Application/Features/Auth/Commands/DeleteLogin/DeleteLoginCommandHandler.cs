using ClimbLog.Api.Services;
using ClimbLog.Application.Interfaces;
using ClimbLog.Domain.Interfaces;
using MediatR;

namespace ClimbLog.Application.Features.Auth.Commands.DeleteLogin;
public class DeleteLoginCommandHandler(IAuthService authService, IStoredProceduresRepository storedProceduresRepository) 
    : IRequestHandler<DeleteLoginCommand, Unit>
{
    public async Task<Unit> Handle(DeleteLoginCommand command, CancellationToken cancellationToken)
    {
        //This will throw an error if the users creds are incorrect
        await authService.LoginAsync(command.Username, command.Password);

        await storedProceduresRepository.DeleteLoginByUsername(command.Username);

        return Unit.Value;
    }
}
