using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SmartParkingAPI.Models.Entities;

namespace SmartParkingAPI.Data.Mappings
{
    public class ParkingSlotMap : IEntityTypeConfiguration<ParkingSlot>
    {
        public void Configure(EntityTypeBuilder<ParkingSlot> builder)
        {
            builder.ToTable("ParkingSlots");

            builder.HasKey(s => s.Id);

            builder.Property(s => s.SlotCode)
                .HasMaxLength(20);

            builder.Property(s => s.IsOccupied)
                .HasDefaultValue(false);

            builder.HasOne(s => s.ParkingLot)
                   .WithMany(p => p.ParkingSlots)
                   .HasForeignKey(s => s.ParkingLotId)
                   .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
