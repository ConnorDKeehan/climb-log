using TimeZoneConverter;

namespace ClimbLog.Application.Utilities;
public static class DateTimeHelper
{
    public static DateTime GetLocalDateFromTimeZone(string timeZoneIdentifier)
    {
        if (string.IsNullOrWhiteSpace(timeZoneIdentifier))
        {
            throw new ArgumentException("TimeZoneIdentifier cannot be null or empty", nameof(timeZoneIdentifier));
        }

        // Convert IANA to Windows format if running on Windows
        string timeZoneId = timeZoneIdentifier;
        if (Environment.OSVersion.Platform == PlatformID.Win32NT)
        {
            timeZoneId = TZConvert.IanaToWindows(timeZoneIdentifier);
        }

        // Find the time zone
        TimeZoneInfo timeZone = TimeZoneInfo.FindSystemTimeZoneById(timeZoneId);

        // Get current UTC time
        DateTime utcNow = DateTime.UtcNow;

        // Convert to local time or return UTC
        return TimeZoneInfo.ConvertTimeFromUtc(utcNow, timeZone);
    }
}
