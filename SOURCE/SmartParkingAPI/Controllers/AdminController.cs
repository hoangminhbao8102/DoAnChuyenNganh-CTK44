using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartParkingAPI.Data.Contexts;
using SmartParkingAPI.Models.DTO;
using SmartParkingAPI.Models.Entities;

namespace SmartParkingAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AdminController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AdminController(AppDbContext context)
        {
            _context = context;
        }

        // 1️. Thống kê tổng quan
        [HttpGet("dashboard")]
        public async Task<IActionResult> GetDashboard()
        {
            var totalUsers = await _context.Users.CountAsync();
            var totalLots = await _context.ParkingLots.CountAsync();
            var totalSlots = await _context.ParkingSlots.CountAsync();
            var totalReservations = await _context.Reservations.CountAsync();
            var occupiedSlots = await _context.ParkingSlots.CountAsync(s => s.IsOccupied);

            return Ok(new
            {
                totalUsers,
                totalLots,
                totalSlots,
                totalReservations,
                occupiedSlots
            });
        }

        // 2️. CRUD: Bãi đậu xe
        [HttpGet("lots")]
        public async Task<IActionResult> GetLots()
        {
            return Ok(await _context.ParkingLots.ToListAsync());
        }

        [HttpPost("lots")]
        public async Task<IActionResult> CreateLot([FromBody] ParkingLot lot)
        {
            _context.ParkingLots.Add(lot);
            await _context.SaveChangesAsync();

            var result = new ParkingLotDto
            {
                Id = lot.Id,
                Name = lot.Name!
            };

            return Ok(result);
        }

        [HttpPut("lots/{id}")]
        public async Task<IActionResult> UpdateLot(int id, [FromBody] ParkingLot lot)
        {
            var exist = await _context.ParkingLots.FindAsync(id);
            if (exist == null) return NotFound();

            exist.Name = lot.Name;
            exist.Address = lot.Address;
            exist.TotalSlots = lot.TotalSlots;
            exist.AvailableSlots = lot.AvailableSlots;

            await _context.SaveChangesAsync();
            return Ok(exist);
        }

        [HttpDelete("lots/{id}")]
        public async Task<IActionResult> DeleteLot(int id)
        {
            var lot = await _context.ParkingLots.FindAsync(id);
            if (lot == null) return NotFound();

            _context.ParkingLots.Remove(lot);
            await _context.SaveChangesAsync();
            return Ok("Deleted");
        }

        // 3️. CRUD: Slot
        [HttpGet("slots")]
        public async Task<IActionResult> GetAllSlots()
        {
            var slots = await _context.ParkingSlots
                .Include(s => s.ParkingLot)
                .Select(s => new ParkingSlotDto
                {
                    Id = s.Id,
                    SlotCode = s.SlotCode,
                    IsOccupied = s.IsOccupied,
                    ParkingLotName = s.ParkingLot != null ? s.ParkingLot.Name : null
                })
                .ToListAsync();

            return Ok(slots);
        }

        [HttpPost("slots")]
        public async Task<IActionResult> CreateSlot([FromBody] ParkingSlot slot)
        {
            var parkingLotExists = await _context.ParkingLots.AnyAsync(l => l.Id == slot.ParkingLotId);
            if (!parkingLotExists)
            {
                return BadRequest($"ParkingLotId {slot.ParkingLotId} does not exist.");
            }

            _context.ParkingSlots.Add(slot);
            await _context.SaveChangesAsync();
            return Ok(slot);
        }

        [HttpPut("slots/{id}")]
        public async Task<IActionResult> UpdateSlot(int id, [FromBody] ParkingSlot slot)
        {
            var exist = await _context.ParkingSlots.FindAsync(id);
            if (exist == null) return NotFound();

            exist.SlotCode = slot.SlotCode;
            exist.IsOccupied = slot.IsOccupied;
            exist.ParkingLotId = slot.ParkingLotId;

            await _context.SaveChangesAsync();
            return Ok(exist);
        }

        [HttpDelete("slots/{id}")]
        public async Task<IActionResult> DeleteSlot(int id)
        {
            var slot = await _context.ParkingSlots.FindAsync(id);
            if (slot == null) return NotFound();

            _context.ParkingSlots.Remove(slot);
            await _context.SaveChangesAsync();
            return Ok("Deleted");
        }
    }
}
