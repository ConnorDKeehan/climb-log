using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.Entities;

public class Facility
{
    public int Id { get; set; }
    public string? IconName { get; set; }
    public required string Name { get; set; }
}
