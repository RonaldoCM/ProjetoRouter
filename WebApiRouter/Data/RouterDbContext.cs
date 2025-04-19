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

    public virtual DbSet<Pessoafisica> Pessoafisicas { get; set; }

    public virtual DbSet<Pessoajuridica> Pessoajuridicas { get; set; }

    public virtual DbSet<PessoajuridicaPessoafisica> PessoajuridicaPessoafisicas { get; set; }

    public virtual DbSet<RotaPessoajuridica> RotaPessoajuridicas { get; set; }

    public virtual DbSet<Rota> Rota { get; set; }

    public virtual DbSet<Situacao> Situacoes { get; set; }

    public virtual DbSet<Tipopessoa> Tipopessoas { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        
    }
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        //=> optionsBuilder.UseMySql("server=127.0.0.1;user=root;password=1964;database=routerdatabase", Microsoft.EntityFrameworkCore.ServerVersion.Parse("8.0.37-mysql"));

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .UseCollation("utf8mb4_0900_ai_ci")
            .HasCharSet("utf8mb4");

        modelBuilder.Entity<Endereco>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("rta_endereco", tb => tb.HasComment("CADASTRO DOS ENDEREÇOS"));

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

        modelBuilder.Entity<Pessoafisica>(entity =>
        {
            entity.HasKey(e => new { e.Id, e.Idtipopessoa })
                .HasName("PRIMARY")
                .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0 });

            entity.ToTable("rta_pessoafisica", tb => tb.HasComment("CADASTRO DE PESSOAS FÍSICAS"));

            entity.HasIndex(e => e.Idtipopessoa, "fk_rta_pessoafisica_rta_tipopessoa1_idx");

            entity.Property(e => e.Id)
                .ValueGeneratedOnAdd()
                .HasColumnName("ID");
            entity.Property(e => e.Idtipopessoa).HasColumnName("IDTIPOPESSOA");
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

            entity.HasOne(d => d.IdtipopessoaNavigation).WithMany(p => p.Pessoafisicas)
                .HasForeignKey(d => d.Idtipopessoa)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_rta_pessoafisica_rta_tipopessoa1");
        });

        modelBuilder.Entity<Pessoajuridica>(entity =>
        {
            entity.HasKey(e => new { e.Id, e.Idtipopessoa, e.Idendereco })
                .HasName("PRIMARY")
                .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0, 0 });

            entity.ToTable("rta_pessoajuridica", tb => tb.HasComment("CADASTRO DAS PESSOAS JURÍDICAS"));

            entity.HasIndex(e => e.Idendereco, "fk_rta_pessoajuridica_rta_endereco1_idx");

            entity.HasIndex(e => e.Idtipopessoa, "fk_rta_pessoajuridica_rta_tipopessoa1_idx");

            entity.Property(e => e.Id)
                .ValueGeneratedOnAdd()
                .HasColumnName("ID");
            entity.Property(e => e.Idtipopessoa).HasColumnName("IDTIPOPESSOA");
            entity.Property(e => e.Idendereco).HasColumnName("IDENDERECO");
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
            entity.Property(e => e.Nome)
                .HasMaxLength(200)
                .HasColumnName("NOME");

            entity.HasOne(d => d.IdenderecoNavigation).WithMany(p => p.Pessoajuridicas)
                .HasForeignKey(d => d.Idendereco)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_rta_pessoajuridica_rta_endereco1");

            entity.HasOne(d => d.IdtipopessoaNavigation).WithMany(p => p.Pessoajuridicas)
                .HasForeignKey(d => d.Idtipopessoa)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_rta_pessoajuridica_rta_tipopessoa1");
        });

        modelBuilder.Entity<PessoajuridicaPessoafisica>(entity =>
        {
            entity.HasKey(e => new { e.Idpj, e.Idpf })
                .HasName("PRIMARY")
                .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0 });

            entity.ToTable("rta_pessoajuridica_pessoafisica");

            entity.HasIndex(e => e.Idpf, "fk_rta_pessoajuridica_has_rta_pessoafisica_rta_pessoafisica_idx");

            entity.HasIndex(e => e.Idpj, "fk_rta_pessoajuridica_has_rta_pessoafisica_rta_pessoajuridi_idx");

            entity.Property(e => e.Idpj).HasColumnName("IDPJ");
            entity.Property(e => e.Idpf).HasColumnName("IDPF");
        });

        modelBuilder.Entity<RotaPessoajuridica>(entity =>
        {
            entity.HasKey(e => new { e.Idrota, e.Idpessoajuridica })
                .HasName("PRIMARY")
                .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0 });

            entity.ToTable("rta_rota_pessoajuridica");

            entity.HasIndex(e => e.Idpessoajuridica, "fk_rta_rota_has_rta_pessoajuridica_rta_pessoajuridica1_idx");

            entity.HasIndex(e => e.Idrota, "fk_rta_rota_has_rta_pessoajuridica_rta_rota1_idx");

            entity.Property(e => e.Idrota).HasColumnName("IDROTA");
            entity.Property(e => e.Idpessoajuridica).HasColumnName("IDPESSOAJURIDICA");
        });

        modelBuilder.Entity<Rota>(entity =>
        {
            entity.HasKey(e => new { e.Id, e.Idsituacao })
                .HasName("PRIMARY")
                .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0 });

            entity.ToTable("rta_rota", tb => tb.HasComment("CADASTRO DAS ROTAS"));

            entity.HasIndex(e => e.Idsituacao, "fk_rta_rota_rta_situacao_idx");

            entity.Property(e => e.Id)
                .ValueGeneratedOnAdd()
                .HasColumnName("ID");
            entity.Property(e => e.Idsituacao).HasColumnName("IDSITUACAO");
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

            entity.HasOne(d => d.IdsituacaoNavigation).WithMany(p => p.Rota)
                .HasForeignKey(d => d.Idsituacao)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_rta_rota_rta_situacao");
        });

        modelBuilder.Entity<Situacao>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("rta_situacao", tb => tb.HasComment("SITUAÇÃO DA ROTA"));

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Nome)
                .HasMaxLength(45)
                .HasColumnName("NOME");
        });

        modelBuilder.Entity<Tipopessoa>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("rta_tipopessoa", tb => tb.HasComment("CADASTRO DOS TIPOS DE PESSOA"));

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Descricao)
                .HasMaxLength(45)
                .HasColumnName("DESCRICAO");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
