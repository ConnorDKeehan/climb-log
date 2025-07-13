using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.Entities;

public class BetaVideo
{
    public int Id { get; set; }
    public int RouteId { get; set; }
    public required string Url { get; set; }
    public string? ThumbnailUrl { get; set; }
}
