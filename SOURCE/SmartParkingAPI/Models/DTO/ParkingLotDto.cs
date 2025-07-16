namespace SmartParkingAPI.Models.DTO
{
    public class ParkingLotDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = default!;
        public List<ParkingSlotDto> Slots { get; set; } = new();
    }
}
