using Microsoft.AspNetCore.Mvc;
using SmartParkingAPI.Models.DTO;
using SmartParkingAPI.Services;

namespace SmartParkingAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ParkingController : ControllerBase
    {
        private readonly IParkingService _service;

        public ParkingController(IParkingService service)
        {
            _service = service;
        }

        [HttpGet("lots")]
        public async Task<IActionResult> GetLots()
        {
            var lots = await _service.GetParkingLotsAsync();
            return Ok(lots);
        }

        [HttpGet("lots/{id}")]
        public async Task<IActionResult> GetLot(int id)
        {
            var lot = await _service.GetParkingLotByIdAsync(id);
            if (lot == null) return NotFound();
            return Ok(lot);
        }

        [HttpPost("reserve")]
        public async Task<IActionResult> Reserve([FromBody] ReservationRequest request)
        {
            var success = await _service.ReserveSlotAsync(request.UserId, request.SlotId);
            if (!success) return BadRequest("Failed to reserve slot.");
            return Ok("Slot reserved successfully.");
        }
    }
}
