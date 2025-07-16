using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SmartParkingAPI.Models.Entities;

namespace SmartParkingAPI.Data.Mappings
{
    public class ParkingLotMap : IEntityTypeConfiguration<ParkingLot>
    {
        public void Configure(EntityTypeBuilder<ParkingLot> builder)
        {
            builder.ToTable("ParkingLots");

            builder.HasKey(p => p.Id);

            builder.Property(p => p.Name)
                .IsRequired()
                .HasMaxLength(100);

            builder.Property(p => p.Address)
                .HasMaxLength(200);

            builder.Property(p => p.TotalSlots)
                .IsRequired();

            builder.Property(p => p.AvailableSlots)
                .IsRequired();

            builder.HasMany(p => p.ParkingSlots)
                   .WithOne(s => s.ParkingLot)
                   .HasForeignKey(s => s.ParkingLotId)
                   .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
