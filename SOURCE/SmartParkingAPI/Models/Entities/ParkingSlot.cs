using SmartParkingAPI.Models.Contracts;

namespace SmartParkingAPI.Models.Entities
{
    public class ParkingSlot : IEntity
    {
        public int Id { get; set; }
        public int ParkingLotId { get; set; }
        public string? SlotCode { get; set; }
        public bool IsOccupied { get; set; }

        public ParkingLot? ParkingLot { get; set; }
    }
}
