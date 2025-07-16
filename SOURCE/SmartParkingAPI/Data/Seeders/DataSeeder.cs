using SmartParkingAPI.Data.Contexts;
using SmartParkingAPI.Models.Entities;

namespace SmartParkingAPI.Data.Seeders
{
    public class DataSeeder : IDataSeeder
    {
        private readonly AppDbContext _dbContext;

        public DataSeeder(AppDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void Initialize()
        {
            _dbContext.Database.EnsureCreated();

            if (_dbContext.Users.Any() || _dbContext.ParkingLots.Any())
                return;

            var users = SeedUsers();
            var lots = SeedParkingLots();
            var slots = SeedParkingSlots(lots);
            SeedReservations(users, slots);
        }

        private List<User> SeedUsers()
        {
            var users = new List<User>
        {
            new() { UserName = "admin", PasswordHash = "hashed_password_1", FullName = "Admin User", Role = "Admin" },
            new() { UserName = "john", PasswordHash = "hashed_password_2", FullName = "John Doe", Role = "Customer" },
            new() { UserName = "jane", PasswordHash = "hashed_password_3", FullName = "Jane Smith", Role = "Customer" }
        };

            _dbContext.Users.AddRange(users);
            _dbContext.SaveChanges();
            return users;
        }

        private List<ParkingLot> SeedParkingLots()
        {
            var lots = new List<ParkingLot>
        {
            new() { Name = "Lot A", Address = "123 Main St", TotalSlots = 5, AvailableSlots = 5 },
            new() { Name = "Lot B", Address = "456 Oak St", TotalSlots = 3, AvailableSlots = 3 }
        };

            _dbContext.ParkingLots.AddRange(lots);
            _dbContext.SaveChanges();
            return lots;
        }

        private List<ParkingSlot> SeedParkingSlots(List<ParkingLot> lots)
        {
            var slots = new List<ParkingSlot>();

            foreach (var lot in lots)
            {
                for (int i = 1; i <= lot.TotalSlots; i++)
                {
                    slots.Add(new ParkingSlot
                    {
                        ParkingLotId = lot.Id,
                        SlotCode = $"{lot.Name?.Replace(" ", "")}-{i}",
                        IsOccupied = false
                    });
                }
            }

            _dbContext.ParkingSlots.AddRange(slots);
            _dbContext.SaveChanges();
            return slots;
        }

        private void SeedReservations(List<User> users, List<ParkingSlot> slots)
        {
            var reservations = new List<Reservation>
        {
            new() {
                UserId = users[1].Id,
                ParkingSlotId = slots[0].Id,
                ReservationTime = DateTime.Now.AddMinutes(-10),
                Status = "Confirmed"
            },
            new() {
                UserId = users[2].Id,
                ParkingSlotId = slots[1].Id,
                ReservationTime = DateTime.Now.AddMinutes(-5),
                Status = "Pending"
            }
        };

            _dbContext.Reservations.AddRange(reservations);
            _dbContext.SaveChanges();
        }
    }
}
