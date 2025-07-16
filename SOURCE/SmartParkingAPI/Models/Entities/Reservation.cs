using SmartParkingAPI.Models.Contracts;

namespace SmartParkingAPI.Models.Entities
{
    public class Reservation : IEntity
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int ParkingSlotId { get; set; }
        public DateTime ReservationTime { get; set; }
        public string? Status { get; set; } // "Confirmed", "Cancelled"

        public User? User { get; set; }
        public ParkingSlot? ParkingSlot { get; set; }
    }
}
