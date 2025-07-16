namespace SmartParkingAPI.Models.DTO
{
    public class ParkingSlotDto
    {
        public int Id { get; set; }
        public string? SlotCode { get; set; }
        public bool IsOccupied { get; set; }
        public string? ParkingLotName { get; set; }
    }
}
