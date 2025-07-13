using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.Entities;
public class Sector
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public decimal XStart { get; set; }
    public decimal XEnd { get; set; }
    public decimal YStart { get; set; }
    public decimal YEnd { get; set; }
    public int GymId { get; set; }
}
