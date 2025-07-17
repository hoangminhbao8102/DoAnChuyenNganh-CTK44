
# 🚗 Smart Parking Management System

Đây là ứng dụng **quản lý bãi đậu xe thông minh**, gồm 2 phần:

- 🧠 Backend: ASP.NET Web API (C# + SQL Server)
- 📱 Frontend: Flutter Mobile App (Android)

---

## 📁 Cấu trúc dự án

```
SmartParking/
├── SmartParkingAPI/        # ASP.NET Web API
└── smart_parking_app/      # Flutter Mobile App
```

---

## ⚙️ Yêu cầu hệ thống

### ✅ Backend (ASP.NET)
- [.NET 7 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/7.0)
- SQL Server (Express hoặc full)
- Visual Studio / VS Code

### ✅ Frontend (Flutter)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Android Emulator hoặc thiết bị thật

---

## 🧱 Database: Thiết lập ban đầu

1. **Tạo cơ sở dữ liệu SQL Server**
2. **Chạy script tạo bảng trong thư mục `DATABASE/SmartParkingDB.sql` hoặc copy đoạn sau:**

```sql
CREATE DATABASE SmartParkingDB;
GO

USE SmartParkingDB;
GO

-- BẢNG NGƯỜI DÙNG
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100),
    Role NVARCHAR(20) -- 'Admin' hoặc 'Customer'
);

-- BẢNG BÃI ĐẬU XE
CREATE TABLE ParkingLots (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200),
    TotalSlots INT NOT NULL,
    AvailableSlots INT NOT NULL
);

-- BẢNG VỊ TRÍ ĐẬU XE
CREATE TABLE ParkingSlots (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ParkingLotId INT FOREIGN KEY REFERENCES ParkingLots(Id),
    SlotCode NVARCHAR(20),
    IsOccupied BIT DEFAULT 0
);

-- BẢNG ĐẶT CHỖ
CREATE TABLE Reservations (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT FOREIGN KEY REFERENCES Users(Id),
    ParkingSlotId INT FOREIGN KEY REFERENCES ParkingSlots(Id),
    ReservationTime DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) -- 'Pending', 'Confirmed', 'Cancelled'
);
```

---

## 🚀 Triển khai Backend

### Bước 1: Mở thư mục `SmartParkingAPI`

```bash
cd SmartParkingAPI
```

### Bước 2: Cấu hình chuỗi kết nối trong `appsettings.json`

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=.;Database=SmartParkingDB;User ID=sa;Password=******;TrustServerCertificate=True;"
}
```

Lưu ý: Lấy Server là lấy máy tính của mình và nếu sử dụng User ID là sa thì phải đặt mật khẩu cho máy tính mình dùng SQL Server

### Bước 3: Apply migration & chạy API

```bash
dotnet ef migrations add InitialCreate
dotnet ef database update
dotnet run
```

Mở trình duyệt: [https://localhost:7082/swagger](https://localhost:7082/swagger)

---

## 📲 Triển khai Flutter App

### Bước 1: Cài đặt Flutter & dependencies

```bash
cd smart_parking_app
flutter pub get
```

### Bước 2: Cập nhật IP kết nối API

Mở `lib/services/api_service.dart` và chỉnh dòng:

```dart
static const String baseUrl = "http://<YOUR_PC_IP>:5041/api";
```

Ví dụ:

```dart
static const String baseUrl = "https://localhost:7082/api";
```

> 📝 **Nếu dùng Android Emulator**, hãy dùng:
> ```dart
> static const String baseUrl = "http://10.0.2.2:5041/api";
> ```

### Bước 3: Chạy ứng dụng

```bash
flutter run
```

---

## ✅ Hoàn tất!

Bạn có thể đăng ký, đăng nhập và trải nghiệm hệ thống.
