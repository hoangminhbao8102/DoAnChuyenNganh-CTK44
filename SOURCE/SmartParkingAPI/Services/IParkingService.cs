using SmartParkingAPI.Models.DTO;

namespace SmartParkingAPI.Services
{
    public interface IParkingService
    {
        Task<List<ParkingLotDto>> GetParkingLotsAsync(CancellationToken cancellationToken = default);
        Task<ParkingLotDto?> GetParkingLotByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<bool> ReserveSlotAsync(int userId, int slotId, CancellationToken cancellationToken = default);
    }
}
