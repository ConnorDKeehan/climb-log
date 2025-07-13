using ClimbLog.Infrastructure.Contexts;
using ClimbLog.Domain.Interfaces;
using Microsoft.EntityFrameworkCore;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Domain.Models.RepoRequests;
using Microsoft.AspNetCore.Mvc.Infrastructure;

namespace ClimbLog.Infrastructure.Repositories;

public class RoutesRepository(ClimbLogContext dbContext) : IRoutesRepository
{
    public async Task<Route> AddRoute(Route route)
    {
        await dbContext.Routes.AddAsync(route);
        await dbContext.SaveChangesAsync();
        return route;
    }
    public async Task ArchiveRoute(int routeId)
    {
        var route = await dbContext.Routes.Where(x => x.Id == routeId).SingleOrDefaultAsync();

        if (route == null) throw new Exception($"Route with Id {routeId} does not exist.");

        route.Archived = true;
        route.DateArchivedUTC = DateTime.UtcNow;
        await dbContext.SaveChangesAsync();
    }
    public async Task ArchiveRoutes(List<int> routeIds)
    {
        var routes = await dbContext.Routes.Where(x => routeIds.Contains(x.Id)).ToListAsync();

        foreach (var route in routes)
        {
            route.Archived = true;
            route.DateArchivedUTC = DateTime.UtcNow;
        }

        await dbContext.SaveChangesAsync();
    }

    public async Task MoveRoute(int routeId, decimal xCord, decimal yCord)
    {
        var route = await dbContext.Routes.FindAsync(routeId);

        if (route == null)
        {
            throw new KeyNotFoundException($"RouteId: {routeId}, can't be found");
        }

        route.XCord = xCord;
        route.YCord = yCord;

        await dbContext.SaveChangesAsync();
    }
    public async Task<Route> GetDetailedRouteById(int routeId)
    {
        var result = await dbContext.Routes
            .Include(x => x.Sector)
            .Include(x => x.Competition)
            .Where(x => x.Id == routeId)
            .SingleAsync();

        var standardGrade = await dbContext.Grades.FindAsync(result.StandardGradeId);
        var grade = await dbContext.Grades.FindAsync(result.GradeId);

        result.StandardGrade = standardGrade;
        result.Grade = grade;

        return result;
    }

    public async Task UpdateRoute(EditRouteRepoRequest request)
    {
        var route = await dbContext.Routes.FindAsync(request.RouteId);

        if (route == null)
        {
            throw new KeyNotFoundException($"RouteId: {request.RouteId} doesn't exist.");
        }

        route.GradeId = request.GradeId;
        route.StandardGradeId = request.StandardGradeId;
        route.CompetitionId = request.CompetitionId;
        route.Points = request.PointValue;
        route.SectorId = request.SectorId;

        await dbContext.SaveChangesAsync();
    }

    public async Task<Route> GetRouteById(int id)
    {
        var route = await dbContext.FindAsync<Route>(id);

        if (route == null)
        {
            throw new KeyNotFoundException($"No Route with ID:{id}");
        }

        return route;
    }

    public async Task BulkAlterCompetition(int competitionId, List<int> routeIds)
    {
        var routes = await dbContext.Routes
            .Where(x => routeIds.Contains(x.Id))
            .ToListAsync();

        foreach (var route in routes)
        {
            route.CompetitionId = competitionId;
        }

        await dbContext.SaveChangesAsync();
    }
}
