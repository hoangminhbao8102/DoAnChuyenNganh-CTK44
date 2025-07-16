using Microsoft.EntityFrameworkCore;
using SmartParkingAPI.Data.Mappings;
using SmartParkingAPI.Models.Entities;

namespace SmartParkingAPI.Data.Contexts
{
    public class AppDbContext : DbContext
    {
        public DbSet<User> Users { get; set; }
        public DbSet<ParkingLot> ParkingLots { get; set; }
        public DbSet<ParkingSlot> ParkingSlots { get; set; }
        public DbSet<Reservation> Reservations { get; set; }

        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration(new UserMap());
            modelBuilder.ApplyConfiguration(new ParkingLotMap());
            modelBuilder.ApplyConfiguration(new ParkingSlotMap());
            modelBuilder.ApplyConfiguration(new ReservationMap());
        }
    }
}
