using Microsoft.Extensions.Logging;

namespace ClimbLog.Domain.Interfaces
{
    public interface ILoggingRespository
    {
        void Log<T>(string message, LogLevel logLevel);
    }
}