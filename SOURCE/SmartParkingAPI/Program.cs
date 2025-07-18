using Microsoft.EntityFrameworkCore;
using SmartParkingAPI.Data.Contexts;
using SmartParkingAPI.Data.Seeders;
using SmartParkingAPI.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Cấu hình DbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Đăng ký dịch vụ DI
builder.Services.AddScoped<IDataSeeder, DataSeeder>();
builder.Services.AddScoped<IParkingService, ParkingService>();

// ✅ Bổ sung CORS policy (cho phép gọi từ Flutter app)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

var app = builder.Build();

// ✅ Chạy Swagger khi ở môi trường phát triển
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// ✅ Khởi tạo dữ liệu mẫu nếu cần
using (var scope = app.Services.CreateScope())
{
    var seeder = scope.ServiceProvider.GetRequiredService<IDataSeeder>();
    seeder.Initialize();
}

// ❌ BỎ hoặc comment dòng này nếu không dùng HTTPS thật
// app.UseHttpsRedirection();

// ✅ Bật CORS trước khi xác thực
app.UseCors("AllowAll");

// ✅ Middleware xác thực
app.UseAuthorization();

// ✅ Routing
app.MapControllers();

// ✅ Bắt đầu chạy
app.Run();
