using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.Entities;
public class ClimasysApiLog
{
    public int Id { get; set; }
    public int? LoginId {  get; set; }
    public required string Message { get; set; }
    public required string Level { get; set; }
    public required string Source { get; set; }
}
