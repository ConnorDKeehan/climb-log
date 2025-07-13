using Microsoft.EntityFrameworkCore;
using ClimbLog.Domain.Models.Entities;
using ClimbLog.Domain.Models.SpResponses;
using ClimbLog.Domain.Models.Views;

namespace ClimbLog.Infrastructure.Contexts
{
    public class ClimbLogContext : DbContext
    {
        public ClimbLogContext(DbContextOptions<ClimbLogContext> options) : base(options)
        {
        }
        public DbSet<GetAllCurentRoutesByGymAndUserSpResponse> GetAllCurentRoutesByGymAndUser { get; set; }
        public DbSet<GetAscentsGroupedByGradeSpResponse> GetAscentsGroupedByGrade { get; set; }
        public DbSet<GetPointsAndAscentsSpResponse> GetPointsAndAscents { get; set; }
        public DbSet<GetCompetitionGroupByRouteIdAndLoginIdSpResponse> GetCompetitionGroupByRouteIdAndLoginId { get; set; }
        public DbSet<GetCompetitionLeaderboardByCompetitionGroupIdSpResponse> GetCompetitionLeaderboardByCompetitionGroupId { get; set; }
        public DbSet<GetAscentsGroupedByGradeByDateSpResponse> GetAscentsGroupedByGradeByDate { get; set; }
        public DbSet<GetPushNotificationTokensByGymNameSpResponse> GetPushNotificationTokensByGymName { get; set; }
        public DbSet<vwMainData> vwMainData { get; set; }
        public DbSet<Domain.Models.Entities.ClimbLog> ClimbLogs { get; set; }
        public DbSet<Grade> Grades { get; set; }
        public DbSet<Gym> Gyms { get; set; }
        public DbSet<Login> Logins { get; set; }
        public DbSet<Route> Routes { get; set; }
        public DbSet<GymAdmin> GymAdmins { get; set; }
        public DbSet<GymDefaultOpeningHour> GymDefaultOpeningHours { get; set; }
        public DbSet<Facility> Facilities { get; set; }
        public DbSet<GymFacility> GymFacilities { get; set; }
        public DbSet<Competition> Competitions { get; set; }
        public DbSet<CompetitionGroup> CompetitionGroups { get; set; }
        public DbSet<CompetitionGroupRule> CompetitionGroupRules { get; set; }
        public DbSet<CompetitionGroupLogin> CompetitionGroupLogins { get; set; }
        public DbSet<GymCompetition> GymCompetitions { get; set; }
        public DbSet<ClimasysApiLog> ClimasysApiLogs { get; set; }
        public DbSet<Sector> Sectors { get; set; }
        public DbSet<BetaVideo> BetaVideos { get; set; }
        public DbSet<DifficultyForGrade> DifficultiesForGrade { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<GetAllCurentRoutesByGymAndUserSpResponse>()
                .HasNoKey();

            modelBuilder.Entity<GetAscentsGroupedByGradeSpResponse>()
                .HasNoKey();

            modelBuilder.Entity<GetPointsAndAscentsSpResponse>()
                .HasNoKey();

            modelBuilder.Entity<GetCompetitionGroupByRouteIdAndLoginIdSpResponse>()
                .HasNoKey();

            modelBuilder.Entity<GetCompetitionLeaderboardByCompetitionGroupIdSpResponse>()
                .HasNoKey();

            modelBuilder.Entity<GetAscentsGroupedByGradeByDateSpResponse>()
                .HasNoKey();

            modelBuilder.Entity<vwMainData>()
                .HasNoKey();

            modelBuilder.Entity<GetPushNotificationTokensByGymNameSpResponse>()
                .HasNoKey();
        }
    }
}
