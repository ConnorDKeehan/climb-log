using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.Entities;
public class GymCompetition
{
    public int Id { get; set; }
    public int GymId { get; set; }
    public int CompetitionId { get; set; }
}
