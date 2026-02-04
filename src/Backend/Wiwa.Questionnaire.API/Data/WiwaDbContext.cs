using Microsoft.EntityFrameworkCore;
using Wiwa.Questionnaire.API.Domain;
using QuestionnaireEntity = Wiwa.Questionnaire.API.Domain.Questionnaire;

namespace Wiwa.Questionnaire.API.Data;

public class WiwaDbContext : DbContext
{
    public WiwaDbContext(DbContextOptions<WiwaDbContext> options) : base(options)
    {
    }

    public DbSet<QuestionnaireType> QuestionnaireTypes { get; set; }
    public DbSet<QuestionnaireEntity> Questionnaires { get; set; }
    public DbSet<Question> Questions { get; set; }
    public DbSet<SpecificQuestionType> SpecificQuestionTypes { get; set; }
    public DbSet<QuestionFormat> QuestionFormats { get; set; }
    public DbSet<PredefinedAnswer> PredefinedAnswers { get; set; }
    public DbSet<PredefinedAnswerSubQuestion> PredefinedAnswerSubQuestions { get; set; }
    public DbSet<QuestionComputedConfig> QuestionComputedConfigs { get; set; }
    public DbSet<QuestionnaireIdentificator> QuestionnaireIdentificators { get; set; }
    public DbSet<QuestionnaireByQuestionnaireIdentificator> QuestionnaireByQuestionnaireIdentificators { get; set; }
    public DbSet<QuestionnaireAnswer> QuestionnaireAnswers { get; set; }
    public DbSet<QuestionnaireIdentificatorType> QuestionnaireIdentificatorTypes { get; set; }
    public DbSet<QuestionnaireTypeReferenceTable> QuestionnaireTypeReferenceTables { get; set; }
    public DbSet<QuestionReferenceColumn> QuestionReferenceColumns { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // QuestionnaireType
        modelBuilder.Entity<QuestionnaireType>(entity =>
        {
            entity.HasKey(e => e.QuestionnaireTypeID);
            entity.Property(e => e.Name).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Code).IsRequired().HasMaxLength(20);
        });

        // SpecificQuestionType
        modelBuilder.Entity<SpecificQuestionType>(entity =>
        {
            entity.HasKey(e => e.SpecificQuestionTypeID);
            entity.Property(e => e.Name).IsRequired().HasMaxLength(50);
        });

        // QuestionFormat
        modelBuilder.Entity<QuestionFormat>(entity =>
        {
            entity.HasKey(e => e.QuestionFormatID);
            entity.Property(e => e.Name).IsRequired().HasMaxLength(50);
            entity.Property(e => e.Code).IsRequired().HasMaxLength(20);
        });

        // Question
        modelBuilder.Entity<Question>(entity =>
        {
            entity.HasKey(e => e.QuestionID);
            entity.Property(e => e.QuestionText).IsRequired().HasMaxLength(500);
            entity.Property(e => e.QuestionLabel).HasMaxLength(50);
            
            entity.HasOne(d => d.QuestionFormat)
                .WithMany()
                .HasForeignKey(d => d.QuestionFormatID)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(d => d.ParentQuestion)
                .WithMany(p => p.SubQuestions)
                .HasForeignKey(d => d.ParentQuestionID)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // PredefinedAnswer
        modelBuilder.Entity<PredefinedAnswer>(entity =>
        {
            entity.HasKey(e => e.PredefinedAnswerID);
            entity.Property(e => e.Answer).IsRequired().HasMaxLength(255);
            entity.Property(e => e.Code).HasMaxLength(20);
            entity.Property(e => e.StatisticalWeight).HasColumnType("decimal(18,2)");

            entity.HasOne(d => d.Question)
                .WithMany(p => p.PredefinedAnswers)
                .HasForeignKey(d => d.QuestionID)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Questionnaire (Mapping Table)
        modelBuilder.Entity<QuestionnaireEntity>(entity =>
        {
            entity.HasKey(e => e.QuestionnaireID);
            
            entity.HasOne(d => d.QuestionnaireType)
                .WithMany(p => p.Questionnaires)
                .HasForeignKey(d => d.QuestionnaireTypeID);

            entity.HasOne(d => d.Question)
                .WithMany()
                .HasForeignKey(d => d.QuestionID);
        });

        // PredefinedAnswerSubQuestion (Mapping Table)
        modelBuilder.Entity<PredefinedAnswerSubQuestion>(entity =>
        {
            entity.HasKey(e => e.PredefinedAnswerSubQuestionID);

            entity.HasOne(d => d.PredefinedAnswer)
                .WithMany(p => p.SubQuestions)
                .HasForeignKey(d => d.PredefinedAnswerID);

            entity.HasOne(d => d.SubQuestion)
                .WithMany()
                .HasForeignKey(d => d.SubQuestionID)
                .OnDelete(DeleteBehavior.Restrict); // Prevent cycles
        });

        // QuestionComputedConfig
        modelBuilder.Entity<QuestionComputedConfig>(entity =>
        {
            entity.HasKey(e => e.QuestionComputedConfigID);
            entity.Property(e => e.RuleName).HasMaxLength(100);
            entity.Property(e => e.MatrixObjectName).HasMaxLength(100);
            entity.Property(e => e.MatrixOutputColumnName).HasMaxLength(100);

            entity.HasOne(d => d.Question)
                .WithMany()
                .HasForeignKey(d => d.QuestionID)
                .OnDelete(DeleteBehavior.Cascade);
        });
        // QuestionnaireIdentificator
        modelBuilder.Entity<QuestionnaireIdentificator>(entity =>
        {
            entity.HasKey(e => e.QuestionnaireIdentificatorID);
            entity.Property(e => e.Identificator).IsRequired().HasMaxLength(20);
        });

        // QuestionnaireByQuestionnaireIdentificator
        modelBuilder.Entity<QuestionnaireByQuestionnaireIdentificator>(entity =>
        {
            entity.HasKey(e => e.QuestionnaireByQuestionnaireIdentificatorID);

            entity.HasOne(d => d.QuestionnaireIdentificator)
                .WithMany(p => p.Questionnaires)
                .HasForeignKey(d => d.QuestionnaireIdentificatorID)
                .OnDelete(DeleteBehavior.Cascade);

             entity.HasOne(e => e.QuestionnaireType)
                .WithMany()
                .HasForeignKey(d => d.QuestionnaireTypeID)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // QuestionnaireAnswer
        modelBuilder.Entity<QuestionnaireAnswer>(entity =>
        {
            entity.HasKey(e => e.QuestionnaireAnswerID);
            entity.Property(e => e.Answer).HasMaxLength(2000);

            entity.HasOne(d => d.QuestionnaireByQuestionnaireIdentificator)
                .WithMany(p => p.Answers)
                .HasForeignKey(d => d.QuestionnaireByQuestionnaireIdentificatorID)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasOne(d => d.Question)
                .WithMany()
                .HasForeignKey(d => d.QuestionID)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(d => d.PredefinedAnswer)
                .WithMany()
                .HasForeignKey(d => d.PredefinedAnswerID)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // QuestionnaireTypeReferenceTable
        modelBuilder.Entity<QuestionnaireTypeReferenceTable>(entity =>
        {
            entity.HasKey(e => e.QuestionnaireTypeReferenceTableID);
            entity.Property(e => e.TableName).IsRequired().HasMaxLength(200);

            entity.HasOne(d => d.QuestionnaireType)
                .WithMany()
                .HasForeignKey(d => d.QuestionnaireTypeID)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // QuestionReferenceColumn
        modelBuilder.Entity<QuestionReferenceColumn>(entity =>
        {
            entity.HasKey(e => e.QuestionReferenceColumnID);
            entity.Property(e => e.ReferenceColumnName).HasMaxLength(200);

            entity.HasOne(d => d.Question)
                .WithMany()
                .HasForeignKey(d => d.QuestionID)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasOne(d => d.QuestionnaireTypeReferenceTable)
                .WithMany(p => p.QuestionReferenceColumns)
                .HasForeignKey(d => d.QuestionnaireTypeReferenceTableID)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}
