namespace WebApiRouter.Models;

public partial class Pessoafisica
{
    public int Id { get; set; }

    public string Codigo { get; set; } = null!;

    public string Nome { get; set; } = null!;

    public string? Cpf { get; set; }

    public sbyte Ativo { get; set; }

    public int Idtipopessoa { get; set; }

    public virtual Tipopessoa IdtipopessoaNavigation { get; set; } = null!;
}
