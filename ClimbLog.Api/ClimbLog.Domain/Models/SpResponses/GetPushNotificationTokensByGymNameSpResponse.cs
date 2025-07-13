using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClimbLog.Domain.Models.SpResponses;
public class GetPushNotificationTokensByGymNameSpResponse
{
    public required string PushNotificationToken { get; set; }
}
