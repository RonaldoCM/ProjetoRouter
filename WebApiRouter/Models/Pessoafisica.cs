namespace WebApiRouter.Models;

public partial class Pessoafisica
{
    public int Id { get; set; }

    public string Codigo { get; set; } = null!;

    public string Nome { get; set; } = null!;

    public string? Cpf { get; set; }

    public sbyte Ativo { get; set; }

    public string? Telefone { get; set; }

    public string? Senha { get; set; }

    public int TipopessoaId { get; set; }

    public virtual Tipopessoa Tipopessoa { get; set; } = null!;

    public virtual ICollection<Pessoajuridica> Pessoajuridicas { get; set; } = new List<Pessoajuridica>();
}
