using ClimbLog.Application.Features.Gym.Queries.GetGymAboutDetails.Models;
using ClimbLog.Application.Features.Gym.Queries.GetGymAboutDetails;
using ClimbLog.Domain.Models.Entities;
using AutoMapper;
using GymEntity = ClimbLog.Domain.Models.Entities.Gym;
using System;

namespace ClimbLog.Application.Features.Gym;

public class GymMappingProfile : Profile
{
    public GymMappingProfile()
    {
        CreateMap<GymFacility, Facility>()
            .ConvertUsing(src => src.Facility!);

        CreateMap<GymDefaultOpeningHour, OpeningHour>()
            .ForMember(dest => dest.DayNumber, opt => opt.MapFrom(src => GetDayNumber(src.WeekDay)))
            .ForMember(dest => dest.WeekDay, opt => opt.MapFrom(src => src.WeekDay))
            .ForMember(dest => dest.StartTime, opt => opt.MapFrom(src => src.StartTime))
            .ForMember(dest => dest.EndTime, opt => opt.MapFrom(src => src.EndTime));

        CreateMap<GymEntity, GetGymAboutDetailsQueryResponse>()
            .ForMember(dest => dest.Facilities, opt => opt.MapFrom(src => src.GymFacilities))
            .ForMember(dest => dest.OpeningHours, opt => opt.MapFrom(src => src.GymDefaultOpeningHours))
            .ForMember(dest => dest.GymName, opt => opt.MapFrom(src => src.Name))
            .ForMember(dest => dest.CurrentlyOpen, opt => opt.MapFrom(src => IsGymCurrentlyOpen(src.GymDefaultOpeningHours))
            )
            .ForMember(dest => dest.TodayStartTime, opt => opt.MapFrom(src => GetTodayStartAndEndTime(src.GymDefaultOpeningHours).Item1))
            .ForMember(dest => dest.TodayEndTime, opt => opt.MapFrom(src => GetTodayStartAndEndTime(src.GymDefaultOpeningHours).Item2));
    }

    private static (TimeOnly?, TimeOnly?) GetTodayStartAndEndTime(List<GymDefaultOpeningHour>? openingHours)
    {
        if (openingHours == null)
            return (null, null);

        var currentDayOfWeek = DateTime.Now.DayOfWeek.ToString();

        var currentDayHours = openingHours.Where(x => x.WeekDay.Equals(currentDayOfWeek, StringComparison.OrdinalIgnoreCase)).SingleOrDefault();

        if (currentDayHours == null)
            return (null, null);

        return (currentDayHours.StartTime, currentDayHours.EndTime);
    }

    private static bool? IsGymCurrentlyOpen(List<GymDefaultOpeningHour>? openingHours)
    {
        (TimeOnly? startTime, TimeOnly? endTime) = GetTodayStartAndEndTime(openingHours);

        if (startTime == null || endTime == null)
            return null;

        var currentTime = TimeOnly.FromDateTime(DateTime.Now);

        var isGymOpen = currentTime >= startTime && currentTime <= endTime;

        return isGymOpen;
    }

    public static int GetDayNumber(string weekDay)
    {
        return weekDay.ToLower() switch
        {
            "monday" => 1,
            "tuesday" => 2,
            "wednesday" => 3,
            "thursday" => 4,
            "friday" => 5,
            "saturday" => 6,
            "sunday" => 7,
            _ => throw new ArgumentException($"{weekDay} is not a valid weekday", weekDay),
        };
    }
}
