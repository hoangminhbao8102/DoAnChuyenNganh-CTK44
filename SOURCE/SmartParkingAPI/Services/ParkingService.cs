using Microsoft.EntityFrameworkCore;
using SmartParkingAPI.Data.Contexts;
using SmartParkingAPI.Models.DTO;
using SmartParkingAPI.Models.Entities;

namespace SmartParkingAPI.Services
{
    public class ParkingService : IParkingService
    {
        private readonly AppDbContext _context;

        public ParkingService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<ParkingLotDto>> GetParkingLotsAsync(CancellationToken cancellationToken = default)
        {
            return await _context.ParkingLots
                .Include(l => l.ParkingSlots)
                .Select(lot => new ParkingLotDto
                {
                    Id = lot.Id,
                    Name = lot.Name!,
                    Slots = lot.ParkingSlots!.Select(slot => new ParkingSlotDto
                    {
                        Id = slot.Id,
                        SlotCode = slot.SlotCode,
                        IsOccupied = slot.IsOccupied
                    }).ToList()
                }).ToListAsync(cancellationToken);
        }

        public async Task<ParkingLotDto?> GetParkingLotByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var lot = await _context.ParkingLots
                .Include(l => l.ParkingSlots)
                .FirstOrDefaultAsync(l => l.Id == id, cancellationToken);

            if (lot == null) return null;

            return new ParkingLotDto
            {
                Id = lot.Id,
                Name = lot.Name!,
                Slots = lot.ParkingSlots!.Select(slot => new ParkingSlotDto
                {
                    Id = slot.Id,
                    SlotCode = slot.SlotCode,
                    IsOccupied = slot.IsOccupied
                }).ToList()
            };
        }

        public async Task<bool> ReserveSlotAsync(int userId, int slotId, CancellationToken cancellationToken = default)
        {
            var slot = await _context.ParkingSlots.FindAsync(slotId);
            if (slot == null || slot.IsOccupied) return false;

            slot.IsOccupied = true;

            var reservation = new Reservation
            {
                UserId = userId,
                ParkingSlotId = slotId,
                ReservationTime = DateTime.Now,
                Status = "Confirmed"
            };

            _context.Reservations.Add(reservation);
            await _context.SaveChangesAsync(cancellationToken);
            return true;
        }
    }
}
