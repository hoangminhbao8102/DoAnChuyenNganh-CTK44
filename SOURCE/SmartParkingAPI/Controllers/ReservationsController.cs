using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartParkingAPI.Data.Contexts;

namespace SmartParkingAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReservationsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ReservationsController(AppDbContext context)
        {
            _context = context;
        }

        // GET: api/reservations/user/1
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetReservationsByUser(int userId)
        {
            var reservations = await _context.Reservations
                .Where(r => r.UserId == userId)
                .ToListAsync();

            return Ok(reservations);
        }

        // DELETE: api/reservations/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> CancelReservation(int id)
        {
            var reservation = await _context.Reservations
                .Include(r => r.ParkingSlot)
                .FirstOrDefaultAsync(r => r.Id == id);

            if (reservation == null)
                return NotFound("Reservation not found");

            reservation.Status = "Cancelled";
            reservation.ParkingSlot!.IsOccupied = false;

            await _context.SaveChangesAsync();

            return Ok("Reservation cancelled");
        }
    }
}
