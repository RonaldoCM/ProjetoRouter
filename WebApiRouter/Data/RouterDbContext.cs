using Microsoft.EntityFrameworkCore;
using WebApiRouter.Models;

namespace WebApiRouter.Data;

public partial class RouterDbContext : DbContext
{
    public RouterDbContext()
    {
    }

    public RouterDbContext(DbContextOptions<RouterDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Endereco> Enderecos { get; set; }

    public virtual DbSet<Finalidade> Finalidades { get; set; }

    public virtual DbSet<Pessoafisica> Pessoafisicas { get; set; }

    public virtual DbSet<Pessoajuridica> Pessoajuridicas { get; set; }

    public virtual DbSet<Rota> Rota { get; set; }

    public virtual DbSet<Servico> Servicos { get; set; }

    public virtual DbSet<SituacaoRota> SituacaoRota { get; set; }

    public virtual DbSet<SituacaoServico> SituacaoServicos { get; set; }

    public virtual DbSet<Tipopessoa> Tipopessoas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .UseCollation("utf8mb3_general_ci")
            .HasCharSet("utf8mb3");

        modelBuilder.Entity<Endereco>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity
                .ToTable("endereco", tb => tb.HasComment("CADASTRO DOS ENDEREÇOS"))
                .HasCharSet("utf8mb4")
                .UseCollation("utf8mb4_0900_ai_ci");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Ativo)
                .HasDefaultValueSql("'1'")
                .HasColumnName("ATIVO");
            entity.Property(e => e.Bairro)
                .HasMaxLength(45)
                .HasColumnName("BAIRRO");
            entity.Property(e => e.Cidade)
                .HasMaxLength(45)
                .HasColumnName("CIDADE");
            entity.Property(e => e.Estado)
                .HasMaxLength(45)
                .HasColumnName("ESTADO");
            entity.Property(e => e.Logradouro)
                .HasMaxLength(45)
                .HasColumnName("LOGRADOURO");
            entity.Property(e => e.Numero)
                .HasMaxLength(45)
                .HasColumnName("NUMERO");
        });

        modelBuilder.Entity<Finalidade>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("finalidade");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Descricao)
                .HasMaxLength(45)
                .HasColumnName("DESCRICAO");
        });

        modelBuilder.Entity<Pessoafisica>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity
                .ToTable("pessoafisica", tb => tb.HasComment("CADASTRO DE PESSOAS FÍSICAS"))
                .HasCharSet("utf8mb4")
                .UseCollation("utf8mb4_0900_ai_ci");

            entity.HasIndex(e => e.TipopessoaId, "fk_PESSOAFISICA_TIPOPESSOA1_idx");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Ativo)
                .HasDefaultValueSql("'1'")
                .HasColumnName("ATIVO");
            entity.Property(e => e.Codigo)
                .HasMaxLength(5)
                .IsFixedLength()
                .HasColumnName("CODIGO");
            entity.Property(e => e.Cpf)
                .HasMaxLength(11)
                .IsFixedLength()
                .HasColumnName("CPF");
            entity.Property(e => e.Nome)
                .HasMaxLength(100)
                .HasColumnName("NOME");
            entity.Property(e => e.Senha)
                .HasMaxLength(4)
                .IsFixedLength()
                .HasColumnName("SENHA");
            entity.Property(e => e.Telefone)
                .HasMaxLength(12)
                .IsFixedLength()
                .HasColumnName("TELEFONE");
            entity.Property(e => e.TipopessoaId).HasColumnName("TIPOPESSOA_ID");

            entity.HasOne(d => d.Tipopessoa).WithMany(p => p.Pessoafisicas)
                .HasForeignKey(d => d.TipopessoaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_PESSOAFISICA_TIPOPESSOA1");
        });

        modelBuilder.Entity<Pessoajuridica>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity
                .ToTable("pessoajuridica", tb => tb.HasComment("CADASTRO DAS PESSOAS JURÍDICAS"))
                .HasCharSet("utf8mb4")
                .UseCollation("utf8mb4_0900_ai_ci");

            entity.HasIndex(e => e.Idendereco, "fk_rta_pessoajuridica_rta_endereco1_idx");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Ativo)
                .HasDefaultValueSql("'1'")
                .HasColumnName("ATIVO");
            entity.Property(e => e.Cnpj)
                .HasMaxLength(14)
                .IsFixedLength()
                .HasColumnName("CNPJ");
            entity.Property(e => e.Codigo)
                .HasMaxLength(5)
                .IsFixedLength()
                .HasColumnName("CODIGO");
            entity.Property(e => e.Idendereco).HasColumnName("IDENDERECO");
            entity.Property(e => e.Nome)
                .HasMaxLength(200)
                .HasColumnName("NOME");
            entity.Property(e => e.Telefone)
                .HasMaxLength(12)
                .IsFixedLength()
                .HasColumnName("TELEFONE");

            entity.HasOne(d => d.IdenderecoNavigation).WithMany(p => p.Pessoajuridicas)
                .HasForeignKey(d => d.Idendereco)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_rta_pessoajuridica_rta_endereco1");

            entity.HasMany(d => d.Pessoafisicas).WithMany(p => p.Pessoajuridicas)
                .UsingEntity<Dictionary<string, object>>(
                    "PessoajuridicaPessoafisica",
                    r => r.HasOne<Pessoafisica>().WithMany()
                        .HasForeignKey("PessoafisicaId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("fk_PESSOAJURIDICA_has_PESSOAFISICA_PESSOAFISICA1"),
                    l => l.HasOne<Pessoajuridica>().WithMany()
                        .HasForeignKey("PessoajuridicaId")
                        .OnDelete(DeleteBehavior.ClientSetNull)
                        .HasConstraintName("fk_PESSOAJURIDICA_has_PESSOAFISICA_PESSOAJURIDICA1"),
                    j =>
                    {
                        j.HasKey("PessoajuridicaId", "PessoafisicaId")
                            .HasName("PRIMARY")
                            .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0 });
                        j
                            .ToTable("pessoajuridica_pessoafisica")
                            .HasCharSet("utf8mb4")
                            .UseCollation("utf8mb4_0900_ai_ci");
                        j.HasIndex(new[] { "PessoafisicaId" }, "fk_PESSOAJURIDICA_has_PESSOAFISICA_PESSOAFISICA1_idx");
                        j.HasIndex(new[] { "PessoajuridicaId" }, "fk_PESSOAJURIDICA_has_PESSOAFISICA_PESSOAJURIDICA1_idx");
                        j.IndexerProperty<int>("PessoajuridicaId").HasColumnName("PESSOAJURIDICA_ID");
                        j.IndexerProperty<int>("PessoafisicaId").HasColumnName("PESSOAFISICA_ID");
                    });
        });

        modelBuilder.Entity<Rota>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity
                .ToTable("rota", tb => tb.HasComment("CADASTRO DAS ROTAS"))
                .HasCharSet("utf8mb4")
                .UseCollation("utf8mb4_0900_ai_ci");

            entity.HasIndex(e => e.SituacaoRotaId, "fk_ROTA_SITUACAO_ROTA1_idx");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Ativo)
                .HasDefaultValueSql("'1'")
                .HasComment("COLUNA PARA VALIDAR SE A ROTA ESTÁ ATIVA OU NÃO.")
                .HasColumnName("ATIVO");
            entity.Property(e => e.Codigo)
                .HasMaxLength(45)
                .HasColumnName("CODIGO");
            entity.Property(e => e.Datacriacao)
                .HasColumnType("datetime")
                .HasColumnName("DATACRIACAO");
            entity.Property(e => e.Datafechamento)
                .HasColumnType("datetime")
                .HasColumnName("DATAFECHAMENTO");
            entity.Property(e => e.Observacao)
                .HasMaxLength(200)
                .HasColumnName("OBSERVACAO");
            entity.Property(e => e.SituacaoRotaId).HasColumnName("SITUACAO_ROTA_ID");

            entity.HasOne(d => d.SituacaoRota).WithMany(p => p.Rota)
                .HasForeignKey(d => d.SituacaoRotaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_ROTA_SITUACAO_ROTA1");
        });

        modelBuilder.Entity<Servico>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("servico");

            entity.HasIndex(e => e.FinalidadeId, "fk_SERVICO_FINALIDADE1_idx");

            entity.HasIndex(e => e.PessoajuridicaId, "fk_SERVICO_PESSOAJURIDICA1_idx");

            entity.HasIndex(e => e.RotaId, "fk_SERVICO_ROTA1_idx");

            entity.HasIndex(e => e.SituacaoServicoId, "fk_SERVICO_SITUACAO_SERVICO_idx");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Datacriacao)
                .HasColumnType("datetime")
                .HasColumnName("DATACRIACAO");
            entity.Property(e => e.Datafechamento)
                .HasColumnType("datetime")
                .HasColumnName("DATAFECHAMENTO");
            entity.Property(e => e.FinalidadeId).HasColumnName("FINALIDADE_ID");
            entity.Property(e => e.PessoajuridicaId).HasColumnName("PESSOAJURIDICA_ID");
            entity.Property(e => e.RotaId).HasColumnName("ROTA_ID");
            entity.Property(e => e.SituacaoServicoId).HasColumnName("SITUACAO_SERVICO_ID");

            entity.HasOne(d => d.Finalidade).WithMany(p => p.Servicos)
                .HasForeignKey(d => d.FinalidadeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_SERVICO_FINALIDADE1");

            entity.HasOne(d => d.Pessoajuridica).WithMany(p => p.Servicos)
                .HasForeignKey(d => d.PessoajuridicaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_SERVICO_PESSOAJURIDICA1");

            entity.HasOne(d => d.Rota).WithMany(p => p.Servicos)
                .HasForeignKey(d => d.RotaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_SERVICO_ROTA1");

            entity.HasOne(d => d.SituacaoServico).WithMany(p => p.Servicos)
                .HasForeignKey(d => d.SituacaoServicoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_SERVICO_SITUACAO_SERVICO");
        });

        modelBuilder.Entity<SituacaoRota>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity
                .ToTable("situacao_rota", tb => tb.HasComment("SITUAÇÃO DA ROTA"))
                .HasCharSet("utf8mb4")
                .UseCollation("utf8mb4_0900_ai_ci");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Nome)
                .HasMaxLength(45)
                .HasColumnName("NOME");
        });

        modelBuilder.Entity<SituacaoServico>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("situacao_servico");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Descricao)
                .HasMaxLength(45)
                .HasColumnName("DESCRICAO");
        });

        modelBuilder.Entity<Tipopessoa>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity
                .ToTable("tipopessoa", tb => tb.HasComment("CADASTRO DOS TIPOS DE PESSOA"))
                .HasCharSet("utf8mb4")
                .UseCollation("utf8mb4_0900_ai_ci");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Descricao)
                .HasMaxLength(45)
                .HasColumnName("DESCRICAO");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
