using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SmartParkingAPI.Models.Entities;

namespace SmartParkingAPI.Data.Mappings
{
    public class ReservationMap : IEntityTypeConfiguration<Reservation>
    {
        public void Configure(EntityTypeBuilder<Reservation> builder)
        {
            builder.ToTable("Reservations");

            builder.HasKey(r => r.Id);

            builder.Property(r => r.ReservationTime)
                .HasColumnType("datetime")
                .HasDefaultValueSql("GETDATE()");

            builder.Property(r => r.Status)
                .HasMaxLength(20);

            builder.HasOne(r => r.User)
                   .WithMany()
                   .HasForeignKey(r => r.UserId)
                   .OnDelete(DeleteBehavior.Cascade);

            builder.HasOne(r => r.ParkingSlot)
                   .WithMany()
                   .HasForeignKey(r => r.ParkingSlotId)
                   .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
