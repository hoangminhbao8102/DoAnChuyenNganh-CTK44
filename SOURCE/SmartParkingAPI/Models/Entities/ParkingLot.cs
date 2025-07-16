using SmartParkingAPI.Models.Contracts;

namespace SmartParkingAPI.Models.Entities
{
    public class ParkingLot : IEntity
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? Address { get; set; }
        public int TotalSlots { get; set; }
        public int AvailableSlots { get; set; }

        public ICollection<ParkingSlot>? ParkingSlots { get; set; }
    }
}
