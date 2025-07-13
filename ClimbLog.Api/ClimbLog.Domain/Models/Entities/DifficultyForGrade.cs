using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.Entities;

public class DifficultyForGrade
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public int Number { get; set; }
}
