using Microsoft.AspNetCore.Http;

namespace ClimbLog.Application.Interfaces
{
    public interface IS3Service
    {
        Task<bool> DeleteFileAsync(string fileName);
        Task<string> UploadFileAsync(string fileName, IFormFile file);
    }
}