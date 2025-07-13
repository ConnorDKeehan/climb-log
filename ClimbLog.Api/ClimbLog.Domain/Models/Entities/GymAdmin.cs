using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.Entities;

public class GymAdmin
{
    public int Id { get; set; }
    public int GymId { get; set; }
    public int LoginId { get; set; }
    //Navigational Properties
    public Gym? Gym { get; set; }
}
