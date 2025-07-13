namespace ClimbLog.Domain.Models.Entities
{
    public class Login
    {
        public int Id { get; set; }
        public required string Username { get; set; }
        public string? Email { get; set; }
        public required string Password { get; set; }
        public string? FriendlyName { get; set; }
        public bool Deleted { get; set; } = false;
        public string? PushNotificationToken { get; set; }
        public string? SocialLoginIdentifier { get; set; }
        public string? ProfilePictureUrl { get; set; }
        public string? BioText { get; set; }
        public DateTime? DateCreatedUtc { get; set; }

        //Navigational Properties
        public List<GymAdmin>? GymAdmins { get; set; }
    }
}
