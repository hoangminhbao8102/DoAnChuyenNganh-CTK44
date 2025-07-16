using SmartParkingAPI.Models.Contracts;

namespace SmartParkingAPI.Models.Entities
{
    public class User : IEntity
    {
        public int Id { get; set; }
        public string? UserName { get; set; }
        public string? PasswordHash { get; set; }
        public string? FullName { get; set; }
        public string? Role { get; set; } // "Admin", "Customer"
    }
}
