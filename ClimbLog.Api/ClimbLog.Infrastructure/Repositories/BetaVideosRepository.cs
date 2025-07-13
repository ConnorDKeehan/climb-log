using ClimbLog.Domain.Interfaces;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Infrastructure.Repositories;
public class BetaVideosRepository(ClimbLogContext dbContext) : IBetaVideosRepository
{
    public async Task<List<BetaVideo>> GetBetaVideosByRouteId(int routeId)
    {
        var result = await dbContext.BetaVideos.Where(x => x.RouteId == routeId).ToListAsync();

        return result;
    }
}
