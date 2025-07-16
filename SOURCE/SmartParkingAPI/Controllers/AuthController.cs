using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SmartParkingAPI.Data.Contexts;
using SmartParkingAPI.Models.DTO;
using SmartParkingAPI.Models.Entities;
using System.Security.Cryptography;
using System.Text;

namespace SmartParkingAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;

        public AuthController(AppDbContext context)
        {
            _context = context;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(UserRegisterModel model)
        {
            if (await _context.Users.AnyAsync(u => u.UserName == model.Username))
                return BadRequest("Username already exists.");

            var user = new User
            {
                UserName = model.Username,
                FullName = model.FullName,
                Role = model.Role,
                PasswordHash = ComputeSha256Hash(model.Password!)
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return Ok("Register successful");
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(UserLoginModel model)
        {
            var hash = ComputeSha256Hash(model.Password!);
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.UserName == model.Username && u.PasswordHash == hash);

            if (user == null)
                return Unauthorized("Invalid username or password");

            return Ok(new
            {
                user.Id,
                user.UserName,
                user.FullName,
                user.Role
            });
        }

        private static string ComputeSha256Hash(string rawData)
        {
            using var sha256 = SHA256.Create();
            var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(rawData));
            return BitConverter.ToString(bytes).Replace("-", "").ToLower();
        }
    }
}
