using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.Entities;

public class GymFacility
{
    public int Id { get; set; }
    public int GymId { get; set; }
    public int FacilityId { get; set; }
    //NavigationalProperties
    public Facility? Facility { get; set; }
}
