namespace SmartParkingAPI.Models.DTO
{
    public class UserRegisterModel
    {
        public string? Username { get; set; }
        public string? Password { get; set; }
        public string? FullName { get; set; }
        public string Role { get; set; } = "Customer";
    }
}
